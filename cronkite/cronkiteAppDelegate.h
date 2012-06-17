#import <UIKit/UIKit.h>
#import "AuthController.h"

@interface CronkiteAppDelegate : UIResponder <UIApplicationDelegate, AuthControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showAuthView;
- (void)showMainView;

@end
