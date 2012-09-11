#import <Foundation/Foundation.h>

@interface FormatUtil : NSObject

+ (NSString *)toISO8601:(NSDate *)date;
+ (NSDate *)parseISO8601:(NSString *)dateString;

@end
