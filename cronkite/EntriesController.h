#import <UIKit/UIKit.h>
#import "EditEntryController.h"
#import "SettingsController.h"

@interface EntriesController : UITableViewController <EditEntryDelegate,
                                                      SettingsControllerDelegate,
                                                      NSFetchedResultsControllerDelegate,
                                                      UISearchDisplayDelegate,
                                                      UISearchBarDelegate>
{
  NSManagedObjectContext *managedObjectContext;  
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *searchResults;

@end
