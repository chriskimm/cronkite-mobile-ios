#import "CronkiteAPI.h"

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
    NSURL *baseUrl = [NSURL URLWithString:@"http://localhost:9393/"];
    client = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
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

- (void)signupWithEmail:(NSString *)email password:(NSString *)password
{
  NSLog(@"Did this signup work: %@", email);
}

- (void)syncWithToken:(NSString *)token
           accountKey:(NSString *)accountKey
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock
{
  NSLog(@"dbug 1 %@", token);
  NSLog(@"dbug 2 %@", accountKey);
  
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            accountKey, @"account_key", 
                            token, @"access_token", nil];
  [client postPath:@"api/sync" parameters:params success:successBlock failure:failureBlock];
}

- (void)logout:(NSString *)accountKey accessToken:(NSString *)token
{
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          accountKey, @"account_key", 
                          token, @"access_token", nil];
  [client deletePath:@"api/auth" parameters:params success:nil failure:nil];
}

@end
