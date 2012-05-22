#import <UIKit/UIKit.h>

@interface AuthController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)signIn:(id)sender;

@end
