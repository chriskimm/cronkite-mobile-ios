#import "CronkiteAPI.h"
#import "DataManager.h"
#import "Environment.h"
#import "Item.h"
#import "AuthUtil.h"
#import "FormatUtil.h"

@implementation CronkiteAPI

static CronkiteAPI *singleton;

+ (CronkiteAPI *)instance
{
  @synchronized(self) {
    if (!singleton) {
        singleton = [[CronkiteAPI alloc] init];      
    }
  }
  return singleton;
}
         
- (id)init 
{
  if (self = [super init]) {
    NSString *apiBase = [[Environment sharedInstance] apiBase];
    NSURL *baseUrl = [NSURL URLWithString:apiBase];
    client = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
  }
  return self;
}

- (void)authWithEmail:(NSString *)email 
                       password:(NSString *)password
                        success:(void (^)(AFHTTPRequestOperation *, id))successBlock
                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          email, @"email", 
                          password, @"password", nil];
  [client postPath:@"api/auth" parameters:params success:successBlock failure:failureBlock];
}

- (void)signupWithEmail:(NSString *)email
             password:(NSString *)password
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          email, @"email",
                          password, @"password", nil];
  [client postPath:@"api/account" parameters:params success:successBlock failure:failureBlock];
}

- (void)syncWithToken:(NSString *)token
           accountKey:(NSString *)accountKey
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock
{
  NSManagedObjectContext *moc = [[DataManager instance] moc];
  
  // Get last updated_at value
  NSFetchRequest *lastModifiedFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
  NSArray *lastModifiedSortDescriptor = 
      [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]];
  [lastModifiedFetchRequest setSortDescriptors:lastModifiedSortDescriptor];
  [lastModifiedFetchRequest setFetchLimit:1];
  NSError *lastModifiedError = nil;
  NSArray *lastModifiedResults = 
      [moc executeFetchRequest:lastModifiedFetchRequest error:&lastModifiedError];
  NSDate *lastModified = nil;
  if ([lastModifiedResults lastObject]) {
    lastModified = [[lastModifiedResults lastObject] valueForKey:@"updated_at"];
  }
  
  if (!lastModified) {
    lastModified = [NSDate distantPast];
  }

  // Get all Items that need to be synced
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
  NSError *error = nil;
  NSPredicate *syncPredicate = [NSPredicate predicateWithFormat:@"sync_status == 1"];
  [fetchRequest setPredicate:syncPredicate];
  [fetchRequest setSortDescriptors:lastModifiedSortDescriptor];
  NSArray *items = [moc executeFetchRequest:fetchRequest error:&error];
  NSMutableArray *itemsJSON = [[NSMutableArray alloc] init];
  for (Item *item in items) {
    [itemsJSON addObject:[item dataDict]];
  }
  
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            accountKey, @"account_key", 
                            [FormatUtil toISO8601:lastModified], @"last_updated_at",
                            itemsJSON, @"items", nil];
  [client setDefaultHeader:@"Authorize" value:[NSString stringWithFormat:@"OAuth %@", token]];
  [client postPath:@"api/sync" parameters:params success:successBlock failure:failureBlock];
}

- (void)logoutWithToken:(NSString *)token accountKey:(NSString *)accountKey
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          accountKey, @"account_key", nil];
  [client setDefaultHeader:@"Authorize" value:[NSString stringWithFormat:@"OAuth %@", token]];
  NSString *path = [NSString stringWithFormat:@"api/token/%@", token];
  [client deletePath:path parameters:params success:nil failure:nil];
}

@end
