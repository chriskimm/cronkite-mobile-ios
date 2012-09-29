#import <UIKit/UIKit.h>
#import "AuthController.h"

@interface LoginController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) id<AuthControllerDelegate> delegate;

- (IBAction)signIn:(id)sender;
- (IBAction)setTestCreds:(id)sender;

@end

