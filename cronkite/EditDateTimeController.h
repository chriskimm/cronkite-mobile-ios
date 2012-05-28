#import <UIKit/UIKit.h>
#import "Entry.h"

@protocol EditDateTimeDelegate;

@interface EditDateTimeController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) id<EditDateTimeDelegate> delegate;
@property (strong, nonatomic) Entry * entry;
@property (strong, nonatomic) IBOutlet UISegmentedControl *wheelSelector;

- (IBAction)dateTimeChanged:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)wheelChanged:(id)sender;
- (void)setDate:(NSDate *)date;

@end

@protocol EditDateTimeDelegate <NSObject>

- (void) editDateTimeController:(EditDateTimeController *)edtc upDate:(NSDate *)date;

@end