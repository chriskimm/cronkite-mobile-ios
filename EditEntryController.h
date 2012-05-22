#import <UIKit/UIKit.h>
#import "Entry.h"

@protocol EditEntryDelegate;

@interface EditEntryController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>
{
  id<EditEntryDelegate> delegate;
  UITextField *text1Field;
}

@property (strong, nonatomic) id<EditEntryDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *text1Field;
@property (strong, nonatomic) Entry *entry;

-(IBAction) cancel:(id)sender;
-(IBAction) done:(id)sender;
-(IBAction) showActionSheet:(id)sender;

@end

@protocol EditEntryDelegate <NSObject>

-(void) editEntryController:(EditEntryController *)eec addEntry:(Entry *)entry;
-(void) editEntryController:(EditEntryController *)eec updateEntry:(Entry *)entry;
-(void) editEntryController:(EditEntryController *)eec deleteEntry:(Entry *)entry;
-(void) cancelEdit:(EditEntryController *)eec;

@end
