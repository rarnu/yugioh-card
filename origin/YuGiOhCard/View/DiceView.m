#import "DiceView.h"
#import "StringConsts.h"

@interface DiceView()

@end

@implementation DiceView

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
    
    self.imgDice = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width-100, self.frame.size.height)];
    [self.imgDice setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgDice setUserInteractionEnabled:YES];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClicked:)];
    [self.imgDice addGestureRecognizer:singleTap];
    
    int diceval = arc4random() % 6 + 1;
    NSString * imgName = [NSString stringWithFormat:@"dice%d", diceval];
    [self.imgDice setImage:[UIImage imageNamed:imgName]];
    
    [self addSubview:self.imgDice];
}

-(void) closeClicked: (id) sender {
    if ([self.delegate respondsToSelector:@selector(doneDice)]) {
        [self.delegate doneDice];
    }
}

@end
