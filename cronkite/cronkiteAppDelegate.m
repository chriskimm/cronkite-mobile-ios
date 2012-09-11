#import "CronkiteAppDelegate.h"
#import "EntriesController.h"
#import "AuthController.h"
#import "DataManager.h"
#import "CronkiteAPI.h"
#import "AuthUtil.h"
#import "Syncer.h"

@implementation CronkiteAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]) {
    [self showMainView];
  } else {
    [self showAuthView];
  }
  return YES;
}

// AuthControllerDelegate impl
- (void)loginComplete
{
  [self showMainView];
}

// AuthControllerDelegate impl
- (void)signupComplete
{
  [self showMainView];
}

- (void)showMainView
{
  UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
  UINavigationController *mainController = 
      (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MainController"];
  self.window.rootViewController = mainController;
  
  EntriesController *entriesController = (EntriesController *)[mainController topViewController];
  entriesController.managedObjectContext = [[DataManager instance] moc];
  
  [[Syncer instance] startListening];
}

- (void)showAuthView
{
  UIStoryboard *storyboard = 
      [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;  
  UINavigationController *welcomeController = 
      (UINavigationController *)[storyboard  instantiateViewControllerWithIdentifier:@"WelcomeController"];
  
  AuthController *authController = (AuthController *)[welcomeController topViewController];
  authController.delegate = self;
  self.window.rootViewController = welcomeController;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [[DataManager instance] saveContext];
}

@end
