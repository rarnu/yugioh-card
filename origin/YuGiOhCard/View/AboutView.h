#import <UIKit/UIKit.h>

@class AboutView;

@protocol AboutViewDelegate <NSObject>

@optional
-(void) aboutview: (AboutView *) view tapped: (BOOL) dismiss;

@end

@interface AboutView : UIView

@property (strong, nonatomic) IBOutlet UILabel * lblVersion;
@property (strong, nonatomic) IBOutlet UILabel * lblPublic;
@property id<AboutViewDelegate> delegate;

@end
