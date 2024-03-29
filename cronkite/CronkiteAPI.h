#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CronkiteAPI : NSObject {
  @private
  AFHTTPClient *client;
}

+ (CronkiteAPI *)instance;

- (void)signupWithEmail:(NSString *)email
             password:(NSString *)password
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock;

- (void)authWithEmail:(NSString *)email 
             password:(NSString *)password
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock;

- (void)syncWithToken:(NSString *)token
           accountKey:(NSString *)accountKey
              success:(void (^)(AFHTTPRequestOperation *, id))successBlock
              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failureBlock;

- (void)logoutWithToken:(NSString *)token accountKey:(NSString *)accountKey;

@end
