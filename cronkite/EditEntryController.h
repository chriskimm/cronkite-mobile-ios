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

@property (nonatomic, strong) id<EditEntryDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *dateButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLocationButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addPhotoButton;
@property (nonatomic, strong) Item *entry;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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
