#import "SettingsController.h"
#import "cronkiteAppDelegate.h"

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
  NSLog(@"button: %d", buttonIndex);
  switch (buttonIndex) {
    case 0: 
      [self logout];
      break;
  }
}

- (void)logout
{
   CronkiteAppDelegate *appDelegate = (CronkiteAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showAuthView];
}

- (void)viewDidUnload
{
  [self setNavBar:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
