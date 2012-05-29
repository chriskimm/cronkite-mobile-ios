#import <UIKit/UIKit.h>
#import "AuthController.h"

@interface SignupController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) id<AuthControllerDelegate> delegate;

- (IBAction)signUpPressed:(id)sender;

@end
