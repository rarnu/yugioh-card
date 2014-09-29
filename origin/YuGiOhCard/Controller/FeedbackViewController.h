#import <UIKit/UIKit.h>


@interface FeedbackViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView * txtFeedback;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * btnSend;

-(IBAction) sendClicked:(id)sender;

@end
