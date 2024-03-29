#import "DataManager.h"
#import "AuthUtil.h"

@implementation DataManager

@synthesize moc = __managedObjectContext;
@synthesize mom = __managedObjectModel;
@synthesize psc = __persistentStoreCoordinator;

+ (DataManager *)instance {
	static DataManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ 
    sharedInstance = [[self alloc] init]; 
  });
	return sharedInstance;
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = [self moc];  // [[DataManager instance] moc];
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      /*
        Replace this implementation with code to handle the error appropriately.
             
        abort() causes the application to generate a crash log and terminate. 
        You should not use this function in a shipping application, although 
        it may be useful during development. 
       */
       NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
       abort();
     } 
  }
}

// Forces a reload of the moc and psc. Use this when logging out
- (void)reset
{
  __persistentStoreCoordinator = nil;
  __managedObjectContext = nil;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)moc
{
  if (__managedObjectContext != nil) {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self psc];
  if (coordinator != nil) {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)mom
{
  if (__managedObjectModel == nil) {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cronkite" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  }
  return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)psc
{
  if (__persistentStoreCoordinator != nil) {
    return __persistentStoreCoordinator;
  }
  NSString *userIdentifier = [AuthUtil currentAccount];
  NSString *fileName = [NSString stringWithFormat:@"cronkite_%@.sqlite", userIdentifier];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
  NSLog(@"storeURL %@", storeURL);
  
  NSError *error = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self mom]];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                  configuration:nil 
                                                            URL:storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use 
     this function in a shipping application, although it may be useful during development. 
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     If the persistent store is not accessible, there is typically something wrong with the file 
     path. Often, a file URL is pointing into the application's resources directory instead of a
     writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their 
     frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the 
     options parameter: 
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
     NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], 
     NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core 
     Data Model Versioning and Data Migration Programming Guide" for details.
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                 inDomains:NSUserDomainMask] lastObject];
}

@end
