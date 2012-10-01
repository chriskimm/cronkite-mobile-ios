#import <UIKit/UIKit.h>
#import "Item.h"
#import "EditDateTimeController.h"
#import <CoreLocation/CoreLocation.h>

@protocol EditEntryDelegate;

@interface EditEntryController : UIViewController <UITextFieldDelegate, 
                                                   UIActionSheetDelegate,
                                                   EditDateTimeDelegate,
                                                   CLLocationManagerDelegate> {
  NSMutableArray *locations;
}

@property (strong, nonatomic) id<EditEntryDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPhotoButton;
@property (strong, nonatomic) Item *entry;
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

- (IBAction)addLocation:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)showActionSheet:(id)sender;

@end

@protocol EditEntryDelegate <NSObject>

- (void) editEntryController:(EditEntryController *)eec addEntry:(Item *)entry;
- (void) editEntryController:(EditEntryController *)eec updateEntry:(Item *)entry;
- (void) cancelEdit:(EditEntryController *)eec;

@end
