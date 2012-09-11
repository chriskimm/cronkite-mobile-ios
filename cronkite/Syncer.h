#import <Foundation/Foundation.h>

@interface Syncer : NSObject

+ (Syncer *)instance;
- (void)sync;
- (void)startListening;
- (void)stopListening;

@end
