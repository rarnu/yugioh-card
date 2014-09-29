#import <UIKit/UIKit.h>

@interface UIBackgroundImageCell : UICollectionViewCell
@property (nonatomic) NSString * imgName;
@property (strong, nonatomic) IBOutlet UIImageView * img;
@property (strong, nonatomic) IBOutlet UIImageView * selectMark;
@end

@interface SettingViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton * btnSpace;
@property (strong, nonatomic) IBOutlet UICollectionView * colImg;

-(IBAction)cleanClicked:(id)sender;

@end
