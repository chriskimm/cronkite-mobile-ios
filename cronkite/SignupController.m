#import "SignupController.h"
#import "AFNetworking.h"

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
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signUpPressed:(id)sender {
  // [self.delegate signupComplete];
  
  NSLog(@"hello sign up email: %@", [self.emailField text]);
  NSLog(@"hello sign up password: %@", [self.passwordField text]);
  
  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9393/"]];
  [client postPath:@"api/account" parameters:
      [NSDictionary dictionaryWithObjectsAndKeys:@"chriskimm@yahoo.com", @"email", @"foo", @"password", nil] 
           success:^( AFHTTPRequestOperation *operation , id responseObject ) {
             NSLog(@"success: %@", [responseObject class]);
           } 
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@", error);
           }];
  NSLog(@"what the hex");
}

@end
