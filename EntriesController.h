#import <UIKit/UIKit.h>
#import "EditEntryController.h"

@interface EntriesController : UITableViewController <EditEntryDelegate, NSFetchedResultsControllerDelegate>
{
  NSManagedObjectContext *managedObjectContext;  
  NSMutableArray *entries;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void) allEntries;
//- (void) addEntry:(id)sender; 

@end
