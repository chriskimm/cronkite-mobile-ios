#import <Foundation/Foundation.h>

@interface DataManager : NSObject {
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *moc;
@property (readonly, strong, nonatomic) NSManagedObjectModel *mom;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *psc;

+ (DataManager *)instance;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)reset;

@end
