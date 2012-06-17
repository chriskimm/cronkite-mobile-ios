#import "AuthUtil.h"

@implementation AuthUtil

+ (NSString *)currentAccount
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"account_key"];
}

+ (NSString *)accessTokenForAccount:(NSString *)account
{
  // account key is not currently used
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
}

+ (NSString *)accessTokenForCurrentAccount
{
  NSString *accountKey = [self currentAccount];
  return [self accessTokenForAccount:accountKey];
}

@end
