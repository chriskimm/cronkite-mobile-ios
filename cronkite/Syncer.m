#import "Syncer.h"
#import "AuthUtil.h"
#import "CronkiteAPI.h"
#import "DataManager.h"
#import "FormatUtil.h"
#import "Item.h"
#import "AFNetworking.h"

@interface Syncer ()
- (void)syncOnNotification:(NSNotification *)notification;
+ (NSManagedObject *)managedItemForGUID:(NSString *)guid;
@end

@implementation Syncer

+ (Syncer *)instance
{
  static Syncer *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[Syncer alloc] init];
  });
  return instance;  
}

- (void)sync
{
  [self stopListening];
  
  void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *oper, id response) {
    //NSLog(@"sync response: %@", response);
    NSArray *items = (NSArray *)[response objectForKey:@"items"];

    NSManagedObjectContext *moc = [[DataManager instance] moc];
    
    for (NSDictionary *item in items) {

      Item *itemMO = (Item *)[Syncer managedItemForGUID:[item valueForKey:@"guid"]];
      if (!itemMO) {
        itemMO = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                              inManagedObjectContext:moc];  

        itemMO.guid = [item valueForKey:@"guid"];
      }
      
      NSLog(@"incoming item: %@", item);
      NSString *text = [item valueForKey:@"text"];
      if (text != (id)[NSNull null]) {
        itemMO.text = text;
      } else {
        itemMO.text = @"null";
      }
      
      NSString *delete_status = [item valueForKey:@"delete_status"];
      itemMO.delete_status = [NSNumber numberWithInt:[delete_status intValue]];
      
      NSString *date_string = [item valueForKey:@"date"];
      NSDate *date = [FormatUtil parseISO8601:date_string];
      itemMO.date = date;

      NSString *updated_at_string = [item valueForKey:@"updated_at"];
      NSDate *up_date = [FormatUtil parseISO8601:updated_at_string];
      itemMO.updated_at = up_date;

      [itemMO setSync_status:[NSNumber numberWithInt:0]]; // TODO: use constant
      
      NSError *error;
      if(![moc save:&error]){
        NSLog(@"ERROR adding item: %@", error);
      }
    }
    [self startListening];
  };
  
  void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *oper, NSError *error) {
    NSLog(@"sync failure: %@", [error debugDescription]);
    [self startListening];
  };  
  
  [[CronkiteAPI instance] syncWithToken:[AuthUtil accessTokenForCurrentAccount]
                             accountKey:[AuthUtil currentAccount]
                                success:successBlock
                                failure:failureBlock];  
}

+ (NSManagedObject *)managedItemForGUID:(NSString *)guid
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"guid == %@", guid]];
  [fetchRequest setFetchLimit:1];
  
  NSError *error = nil;
  NSArray *results = 
      [[[DataManager instance] moc] executeFetchRequest:fetchRequest error:&error];
  
  if ([results lastObject]) {
    NSLog(@"last obj: %@", [results lastObject]);
    //lastModified = [[results lastObject] valueForKey:@"updated_at"];
    return [results lastObject];
  }

  return nil;
}

- (void)syncOnNotification:(NSNotification *)notification
{
  [self sync];
}

- (void)startListening
{
  NSLog(@"Syncer starting to listen");
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(syncOnNotification:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:[[DataManager instance] moc]];      
}

- (void)stopListening
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:NSManagedObjectContextDidSaveNotification
                                                object:nil];  
}

@end
