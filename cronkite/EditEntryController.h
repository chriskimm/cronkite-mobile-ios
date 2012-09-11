#import <UIKit/UIKit.h>
#import "Item.h"
#import "EditDateTimeController.h"
#import <CoreLocation/CoreLocation.h>

@protocol EditEntryDelegate;

@interface EditEntryController : UIViewController <UITextFieldDelegate, 
                                                   UIActionSheetDelegate,
                                                   EditDateTimeDelegate,
                                                   CLLocationManagerDelegate> {
  id<EditEntryDelegate> delegate;
  UITextField *textField;
  CLLocationManager *locationManager;
  NSMutableArray *locations;
}

@property (nonatomic, strong) id<EditEntryDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPhotoButton;
@property (nonatomic, strong) Item *entry;
@property (nonatomic, retain) CLLocationManager *locationManager;

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
