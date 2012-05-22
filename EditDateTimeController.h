#import <UIKit/UIKit.h>

@interface EditDateTimeController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;

- (IBAction)dateTimeChanged:(id)sender;
- (IBAction)done:(id)sender;

@end
