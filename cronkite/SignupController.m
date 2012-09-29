#import "SignupController.h"
#import "AFNetworking.h"
#import "CronkiteAPI.h"

@implementation SignupController

@synthesize emailField;
@synthesize passwordField;
@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [self setEmailField:nil];
  [self setPasswordField:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signUpPressed:(id)sender {

  void (^mySuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *oper, id response) {
    NSString *auth_token = [response valueForKey:@"auth_token"];
    NSString *account_key = [response valueForKey:@"account_key"];
    [[NSUserDefaults standardUserDefaults] setValue:account_key forKey:@"account_key"];
    [[NSUserDefaults standardUserDefaults] setValue:auth_token forKey:@"auth_token"];
    [self.delegate signupComplete];
  };
  
  void (^myFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *oper, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup Error"
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  };
  
  
  [[CronkiteAPI instance] signupWithEmail:[self.emailField text]
                                 password:[self.passwordField text]
                                  success:mySuccess failure:myFailure];
}

@end
