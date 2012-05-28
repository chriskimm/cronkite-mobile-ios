#import "AuthController.h"
#import "LoginController.h"

@implementation AuthController

@synthesize delegate;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Login"]) {
    LoginController *lc = (LoginController *)[segue destinationViewController];
    lc.delegate = delegate;    
  } else if ([segue.identifier isEqualToString:@"Signup"]) {
    NSLog(@"signup not implemented yet");
  }
}

@end
