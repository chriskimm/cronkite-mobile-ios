#import <UIKit/UIKit.h>

@protocol AuthControllerDelegate;

@interface AuthController : UIViewController

@property (strong, nonatomic) id<AuthControllerDelegate> delegate;

@end


@protocol AuthControllerDelegate <NSObject>

- (void)loginComplete;
- (void)signupComplete;

@end