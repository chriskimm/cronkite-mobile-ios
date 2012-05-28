#import "LoginController.h"

@implementation LoginController
@synthesize username;
@synthesize password;
@synthesize delegate;

- (IBAction)signIn:(id)sender {
  NSLog(@"username: %@", [username text]);
  NSLog(@"password: %@", [password text]);
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
