#import "EditDateTimeController.h"

@implementation EditDateTimeController

@synthesize dateTimePicker;
@synthesize dateLabel;
@synthesize delegate;
@synthesize entry = _entry;
@synthesize wheelSelector;

bool dirty = FALSE;

- (IBAction)done:(id)sender {
  [self.delegate editDateTimeController:self upDate:[self.dateTimePicker date]];
}

- (IBAction)wheelChanged:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
  NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
   
  if (selectedSegment == 0) {
    [self.dateTimePicker setDatePickerMode:UIDatePickerModeDate];
  } else {
    [self.dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
  }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.dateTimePicker setDate:[self.entry date]];
  [self setDate:[self.entry date]];
}


- (void)viewDidUnload
{
  [self setDateTimePicker:nil];
  [self setDateLabel:nil];
    [self setWheelSelector:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dateTimeChanged:(id)sender {
  NSDate * date = [self.dateTimePicker date];
  [self setDate:date];
  [self.entry setDate:date];
  dirty = TRUE;
}



- (void)setDate:(NSDate *)date
{
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
  }
  self.dateLabel.text = [dateFormatter stringFromDate:date];
}

@end
