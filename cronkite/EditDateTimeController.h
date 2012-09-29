#import <UIKit/UIKit.h>
#import "Item.h"

@protocol EditDateTimeDelegate;

@interface EditDateTimeController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) id<EditDateTimeDelegate> delegate;
//@property (strong, nonatomic) Item * entry;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) IBOutlet UISegmentedControl *wheelSelector;

- (IBAction)dateTimeChanged:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)wheelChanged:(id)sender;
//- (void)setDate:(NSDate *)date;

@end

@protocol EditDateTimeDelegate <NSObject>

- (void)editDateTimeController:(EditDateTimeController *)edtc upDate:(NSDate *)date;

@end