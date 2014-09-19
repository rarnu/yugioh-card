#import "CardInfoViewController.h"
#import "CardViewController.h"
#import "CardItem.h"
#import "StringConsts.h"
#import "CardConsts.h"

@interface CardInfoViewController ()

@property (nonatomic) CardItem * card;

@end

@implementation CardInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.card = ((CardViewController *)self.tabBarController).card;
    
    NSString * str = [NSString stringWithFormat:CARD_BASE_INFO, self.card.name, self.card.japName, self.card.enName, self.card.sCardType];
    if ([self.card.sCardType rangeOfString:_monster].location != NSNotFound) {
        str = [str stringByAppendingString:LINE];
        NSString * level = [NSString stringWithFormat:@"%ld", (long)self.card.level];
        if ([self.card.sCardType rangeOfString:CARD_XYZ].location != NSNotFound) {
            level = [level stringByAppendingString:CARD_RANK];
        }
        str = [str stringByAppendingFormat:CARD_MONSTER_INFO, self.card.element, level, self.card.tribe, self.card.atk, self.card.def];
        if ([self.card.cardDType rangeOfString:MONSTER_PENDULUM].location != NSNotFound) {
            str = [str stringByAppendingFormat:MONSTER_PENDULUM_SCALE, (long)self.card.pendulumL, (long)self.card.pendulumR];
        }
    }
    str = [str stringByAppendingString:LINE];
    str = [str stringByAppendingFormat:CARD_EXTRA_INFO, self.card.ban, self.card.package, self.card.cardCamp, self.card.cheatcode, self.card.infrequence];
    
    str = [str stringByAppendingString:LINE];
    str = [str stringByAppendingFormat:CARD_EFFECT_INFO, self.card.effect];
    
    self.txtInfo.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
