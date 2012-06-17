#import "Item.h"

@implementation Item

@synthesize guid = _guid;
@synthesize created = _created;
@synthesize modified = _modified;
@synthesize text = _text;
@synthesize date = _date;
@synthesize syncStatus = _syncStatus;

- (id)initWithText:(NSString *)text
{
  return [self initWithText:text andDate:[NSDate date]];
}

- (id)initWithText:(NSString *)text andDate:(NSDate *)date_
{
  if(self != nil) {
    self.text = text;
    self.date = date_;
    //self.guid = [self genUUID];
    //self.syncStatus = kQueued;
  }
  return self; 
}

- (void)awakeFromInsert
{
  [super awakeFromInsert];
  NSLog(@"awakeFromInsert called...");
  [self setCreated:[NSDate date]];
  [self setGuid:[self genUUID]];
  [self setSyncStatus:kQueued];
}

- (NSString *)genUUID
{
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
  CFRelease(uuid);
  return uuidString;
}

@end
