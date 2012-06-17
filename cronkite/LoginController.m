#import "LoginController.h"
#import "CronkiteAPI.h"
#import "AFNetworking.h"

@implementation LoginController
@synthesize username;
@synthesize password;
@synthesize delegate;

- (IBAction)signIn:(id)sender {
  NSString *email = [username text];
  NSString *pass = [password text];

  void (^mySuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *oper, id response) {
    NSString *access_token = [response valueForKey:@"access_token"];
    NSString *account_key = [response valueForKey:@"account_key"];
    NSLog(@"login success response: %@", response);
    [[NSUserDefaults standardUserDefaults] setValue:access_token forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue:account_key forKey:@"account_key"];
    [self.delegate loginComplete];
  };

  void (^myFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *oper, NSError *error) {
    NSString *errorMessage;
    switch([[oper response] statusCode]) {
      case 401:
        errorMessage = @"Email and password don't match.";
        break;
      case 404:
        errorMessage = @"Invalid login. Please try again.";
        break;
      default:
        errorMessage = [error localizedDescription];
        break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  };
  
  [[CronkiteAPI instance] authWithEmail:email password:pass success:mySuccess failure:myFailure];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.username || textField == self.password) {
    [textField resignFirstResponder];
  }
  return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [self setUsername:nil];
  [self setPassword:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
