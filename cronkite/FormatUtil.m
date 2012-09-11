#import "FormatUtil.h"

@interface FormatUtil()
+ (NSDateFormatter *)iso8601formatter;
@end

@implementation FormatUtil

static NSString * const ISO_8601_FORMAT = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

+ (NSString *)toISO8601:(NSDate *)date
{
  NSDateFormatter *formatter = [FormatUtil iso8601formatter]; 
  return [formatter stringFromDate:date];
}

+ (NSDate *)parseISO8601:(NSString *)dateString
{
  NSDateFormatter *formatter = [FormatUtil iso8601formatter];
  return [formatter dateFromString:dateString];
}

+ (NSDateFormatter *)iso8601formatter
{
  static NSDateFormatter *formatter = nil;
  if (formatter == nil) {
    formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:ISO_8601_FORMAT];
  }
  return formatter;
}

@end
