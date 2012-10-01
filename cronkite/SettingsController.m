#import "SettingsController.h"
#import "cronkiteAppDelegate.h"
#import "AuthUtil.h"
#import "CronkiteAPI.h"
#import "DataManager.h"

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
  [[CronkiteAPI instance] logoutWithToken:accessToken accountKey:accountKey];
  
  [AuthUtil clear];
  [[DataManager instance] reset];
  
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
