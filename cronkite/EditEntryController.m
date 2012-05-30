#import "EditEntryController.h"

@implementation EditEntryController

@synthesize delegate;
@synthesize text1Field;
@synthesize dateButton;
@synthesize entry = _entry;

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
  if([self.text1Field.text length] <= 0) {
    NSLog(@"You have not entered a name for this task %@",self.text1Field.text);
    return;
  }

  self.entry.text1 = self.text1Field.text;
  
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSDate *date = [NSDate date];
  if (self.entry == NULL) {
    newEntry = TRUE;
    self.entry = [[Entry alloc] initWithText:@""];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                    initWithTitle: @"Cancel" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
  } else {
    newEntry = FALSE;
    self.text1Field.text = self.entry.text1;
    date = self.entry.date;
  }

  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
  }

  [self.dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)viewDidUnload {
  [self setDateButton:nil];
  [self setText1Field:nil];
  [super viewDidUnload];
}
@end
