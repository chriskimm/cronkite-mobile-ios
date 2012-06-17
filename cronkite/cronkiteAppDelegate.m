#import "CronkiteAppDelegate.h"
#import "EntriesController.h"
#import "AuthController.h"
#import "DataManager.h"
#import "CronkiteAPI.h"
#import "AuthUtil.h"

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
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sync:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:[[DataManager instance] moc]];    
}

- (void)sync:(NSNotification *)notification
{
  //Collect items to be synced
  
  void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *oper, id response) {
    NSLog(@"sync response: %@", response);
  };
  
  void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *oper, NSError *error) {
    NSLog(@"sync failure: %@", [error debugDescription]);
  };  

  [[CronkiteAPI instance] syncWithToken:[AuthUtil accessTokenForCurrentAccount]
                             accountKey:[AuthUtil currentAccount]
                                success:successBlock
                                failure:failureBlock];
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

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:NSManagedObjectContextDidSaveNotification
                                                object:nil];
}

@end
