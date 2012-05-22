#import "EditEntryController.h"

@implementation EditEntryController

@synthesize delegate;
@synthesize text1Field;
@synthesize entry = _entry;

#pragma mark - Actions
-(IBAction)cancel:(id)sender {
  [self.delegate cancelEdit:self];
}

-(IBAction)done:(id)sender{
  if([self.text1Field.text length] <= 0) {
    NSLog(@"You have not entered a name for this task %@",self.text1Field.text);
    return;
  }
  
  if (self.entry == NULL) {
    Entry *entry = [[Entry alloc] initWithText:self.text1Field.text];
    [self.delegate editEntryController:self addEntry:entry];
  } else {
    self.entry.text1 = self.text1Field.text;
    [self.delegate editEntryController:self updateEntry:self.entry];
  }
}

-(IBAction)showActionSheet:(id)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self 
                                                 cancelButtonTitle:@"Cancel Button" 
                                            destructiveButtonTitle:@"Delete Entry" 
                                                 otherButtonTitles:nil, nil];
  [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"button: %d", buttonIndex);
  switch (buttonIndex) {
    case 0: 
      [self.delegate editEntryController:self deleteEntry:self.entry];
      break;
  }
}
  

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (self.entry == NULL) {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                    initWithTitle: @"Cancel" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
  } else {
    self.text1Field.text = self.entry.text1;
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
