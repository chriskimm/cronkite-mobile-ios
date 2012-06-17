#import "EditEntryController.h"

@implementation EditEntryController

@synthesize delegate;
@synthesize textField;
@synthesize dateButton;
@synthesize addLocationButton;
@synthesize addPhotoButton;
@synthesize entry = _entry;
@synthesize locationManager;

BOOL newEntry = TRUE;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"editDateTime"]) {
    EditDateTimeController *edtc = (EditDateTimeController *)[segue destinationViewController];
    edtc.delegate = self;   
    edtc.entry = self.entry;
  }
}

#pragma mark - Actions
-(IBAction)cancel:(id)sender {
  [self.delegate cancelEdit:self];
}

-(IBAction)done:(id)sender{
  if([self.textField.text length] <= 0) {
    NSLog(@"You have not entered a name for this task %@",self.textField.text);
    return;
  }

  self.entry.text = self.textField.text;
  
  if (newEntry) {
    [self.delegate editEntryController:self addEntry:self.entry];
  } else {
    [self.delegate editEntryController:self updateEntry:self.entry];
  }
}

-(IBAction)showActionSheet:(id)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self 
                                                 cancelButtonTitle:@"Cancel" 
                                            destructiveButtonTitle:@"Delete Entry" 
                                                 otherButtonTitles:nil, nil];
  [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0: 
      [self.delegate editEntryController:self deleteEntry:self.entry];
      break;
  }
}
  
- (void) editDateTimeController:(EditDateTimeController *)edtc upDate:(NSDate *)date
{
  self.dateButton.titleLabel.text = [date description];
  [[self navigationController] popViewControllerAnimated:YES];
}

- (CLLocationManager *)locationManager
{
  if (locationManager != nil) {
    return locationManager;    
  }
  locationManager = [[CLLocationManager alloc] init];
  locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
  locationManager.delegate = self;
  return locationManager;
}

- (IBAction)addLocation:(id)sender {
  NSLog(@"add me some location!");
}

// CLLocatinManagerDelegate
- (void)location:(CLLocationManager *)managerdidUpdateToLocation:(CLLocation *)newLocation
  fromLocation:(CLLocation *)oldLocation {
  addLocationButton.enabled = YES;
}

// CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error 
{
  addLocationButton.enabled = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSDate *date = [NSDate date];
  if (self.entry == NULL) {
    newEntry = TRUE;
    self.entry = [[Item alloc] initWithText:@""];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                    initWithTitle: @"Cancel" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
  } else {
    newEntry = FALSE;
    self.textField.text = self.entry.text;
    date = self.entry.date;
  }

  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
  }

  [self.dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
  [[self locationManager] startUpdatingLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)viewDidUnload {
  [self setDateButton:nil];
  [self setTextField:nil];
  [self setAddLocationButton:nil];
  [self setAddPhotoButton:nil];
  [self setLocationManager:nil];
  [super viewDidUnload];
}
@end
