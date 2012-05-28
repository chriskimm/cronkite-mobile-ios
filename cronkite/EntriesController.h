#import <UIKit/UIKit.h>
#import "EditEntryController.h"
#import "SettingsController.h"

@interface EntriesController : UITableViewController <EditEntryDelegate,
                                                      SettingsControllerDelegate,
                                                      NSFetchedResultsControllerDelegate>
{
  NSManagedObjectContext *managedObjectContext;  
  NSMutableArray *entries;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void) allEntries;

@end
