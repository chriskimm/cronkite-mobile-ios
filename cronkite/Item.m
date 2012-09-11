#import "Item.h"
#import "Location.h"
#import "FormatUtil.h"

@implementation Item

@dynamic created;
@dynamic date;
@dynamic guid;
@dynamic updated_at;
@dynamic sync_status;
@dynamic delete_status;
@dynamic text;
@dynamic locations;

- (void)awakeFromInsert
{
  [super awakeFromInsert];
  [self setCreated:[NSDate date]];
  [self setGuid:[self genUUID]];
  [self setSync_status:[NSNumber numberWithInt:1]];
}

- (NSString *)genUUID
{
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
  CFRelease(uuid);
  return uuidString;
}

- (NSDictionary *)dataDict
{
  NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                        [FormatUtil toISO8601:self.date], @"date",
                        self.guid, @"guid",
                        self.delete_status, @"delete_status",
                        self.text, @"text", nil];
  return data;
}

@end
