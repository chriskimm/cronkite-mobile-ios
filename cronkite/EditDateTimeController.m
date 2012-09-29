#import "EditDateTimeController.h"

@implementation EditDateTimeController

@synthesize dateTimePicker;
@synthesize dateLabel;
@synthesize delegate;
@synthesize date;
@synthesize wheelSelector;

bool dirty = FALSE;

- (IBAction)done:(id)sender {
  //[self.delegate editDateTimeController:self upDate:[self.dateTimePicker date]];
  [self.delegate editDateTimeController:self upDate:self.date];
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
  [self setFormattedDate:self.date];
  [self.dateTimePicker setDate:date];
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
  NSDate *newDate = [self.dateTimePicker date];
  self.date = newDate;
  [self setFormattedDate:date];
  dirty = TRUE;
}

- (void)setFormattedDate:(NSDate *)newDate
{
  NSLog(@"editDateTimeController#setDate: %@", newDate);
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
  }
  self.dateLabel.text = [dateFormatter stringFromDate:newDate];
}

@end
