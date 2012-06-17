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
  
  
  NSURL *baseUrl = [NSURL URLWithString:@"http://localhost:9393/"];
  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
  [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [client setDefaultHeader:@"Accept" value:@"application/json"];
  
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [self.emailField text], @"email", 
                          [self.passwordField text], @"password", nil];
  
  [client postPath:@"api/account" parameters:params        
           success:^( AFHTTPRequestOperation *operation , id responseObject) {
             NSLog(@"success 1: %@", [responseObject class]);
             NSLog(@"success 2: %@", responseObject);
             NSString *auth_token = [responseObject valueForKey:@"auth_token"];
             NSLog(@"value for auth_token: %@", auth_token);
             [[NSUserDefaults standardUserDefaults] setValue:auth_token forKey:@"auth_token"];
             [self.delegate signupComplete];
           } 
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@", error);
           }];
}

@end
