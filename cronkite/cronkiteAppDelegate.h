#import <UIKit/UIKit.h>
#import "AuthController.h"

@interface CronkiteAppDelegate : UIResponder <UIApplicationDelegate, AuthControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)showAuthView;
- (void)showMainView;

- (NSURL *)applicationDocumentsDirectory;

@end
