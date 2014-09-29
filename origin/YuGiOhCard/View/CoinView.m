#import "CoinView.h"
#import "StringConsts.h"

@interface CoinView()
@end

@implementation CoinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void) makeUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.imgCoin = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width-100, self.frame.size.height)];
    [self.imgCoin setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgCoin setUserInteractionEnabled:YES];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClicked:)];
    [self.imgCoin addGestureRecognizer:singleTap];
    
    int coinval = arc4random() % 2 + 1;
    NSString * imgName = [NSString stringWithFormat:@"coin%d", coinval];
    [self.imgCoin setImage:[UIImage imageNamed:imgName]];
    
    [self addSubview:self.imgCoin];
}

-(void) closeClicked: (id) sender {
    if ([self.delegate respondsToSelector:@selector(doneCoin)]) {
        [self.delegate doneCoin];
    }
}

@end
