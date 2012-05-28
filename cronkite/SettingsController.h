#import <UIKit/UIKit.h>

@protocol SettingsControllerDelegate;

@interface SettingsController : UIViewController <UIActionSheetDelegate>

- (IBAction)done:(id)sender;

@property (strong, nonatomic) id<SettingsControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction) showActionSheet:(id)sender;
- (IBAction)done:(id)sender;

- (void)logout;

@end

@protocol SettingsControllerDelegate <NSObject>

- (void)settingsDone;

@end