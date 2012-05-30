#import "LoginController.h"
#import "CronkiteAPI.h"

@implementation LoginController
@synthesize username;
@synthesize password;
@synthesize delegate;

- (IBAction)signIn:(id)sender {
  NSString *email = [username text];
  NSString *pass = [password text];
  
  NSLog(@"username: %@", email);
  NSLog(@"password: %@", pass);
  [CronkiteAPI authWithEmail:email password:pass];
  [self.delegate loginComplete];
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
