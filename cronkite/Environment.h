#import <Foundation/Foundation.h>

@interface Environment : NSObject {
}

@property (nonatomic, retain) NSString *apiBase;

+ (Environment *)sharedInstance;

@end