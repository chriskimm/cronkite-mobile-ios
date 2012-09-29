#import <Foundation/Foundation.h>

@interface AuthUtil : NSObject

+ (NSString *)currentAccount;
+ (NSString *)accessTokenForAccount:(NSString *)account;
+ (NSString *)accessTokenForCurrentAccount;
+ (void)clear;

@end
