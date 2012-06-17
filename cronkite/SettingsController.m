#import "SettingsController.h"
#import "cronkiteAppDelegate.h"
#import "CronkiteAPI.h"
#import "AuthUtil.h"

@implementation SettingsController

@synthesize navBar;
@synthesize delegate;

#pragma mark - View lifecycle

- (void)showActionSheet:(id)sender
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                             destructiveButtonTitle:@"Logout" 
                                                  otherButtonTitles:nil, nil];
  [actionSheet showInView:self.view]; 
}

- (IBAction)done:(id)sender {
  [self.delegate settingsDone];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0: 
      [self logout];
      break;
  }
}

- (void)logout
{
  NSString *accountKey = [AuthUtil currentAccount];
  NSString *accessToken = [AuthUtil accessTokenForCurrentAccount];
  [[CronkiteAPI instance] logout:accountKey accessToken:accessToken];
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account_key"];

  CronkiteAppDelegate *appDelegate = 
      (CronkiteAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showAuthView];
}

- (void)viewDidUnload
{
  [self setNavBar:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
