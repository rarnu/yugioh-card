#import "CardInfoViewController.h"
#import "CardViewController.h"
#import "CardItem.h"

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
    
    NSString * line = @"--------------------------------------------------\n";
    
    NSString * str = [NSString stringWithFormat:@"卡片名称: %@\n日文名称: %@\n英文名称: %@\n卡片种类: %@\n", self.card.name, self.card.japName, self.card.enName, self.card.sCardType];
    if ([self.card.sCardType rangeOfString:@"怪兽"].location != NSNotFound) {
        str = [str stringByAppendingString:line];
        NSString * level = [NSString stringWithFormat:@"%ld", (long)self.card.level];
        if ([self.card.sCardType rangeOfString:@"XYZ"].location != NSNotFound) {
            level = [level stringByAppendingString:@" 阶"];
        }
        str = [str stringByAppendingFormat:@"卡片属性: %@\n星数阶级: %@\n卡片种族: %@\n攻击力: %@\n守备力: %@\n", self.card.element, level, self.card.tribe, self.card.atk, self.card.def];
        if ([self.card.cardDType rangeOfString:@"灵摆"].location != NSNotFound) {
            str = [str stringByAppendingFormat:@"灵摆刻度: 左(%ld)右(%ld)\n", (long)self.card.pendulumL, (long)self.card.pendulumR];
        }
    }
    str = [str stringByAppendingString:line];
    str = [str stringByAppendingFormat:@"卡片限制: %@\n所在卡包: %@\n卡片归属: %@\n卡片密码: %@\n罕贵程度: %@\n", self.card.ban, self.card.package, self.card.cardCamp, self.card.cheatcode, self.card.infrequence];
    
    str = [str stringByAppendingString:line];
    str = [str stringByAppendingFormat:@"卡片效果: \n%@\n", self.card.effect];
    
    self.txtInfo.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
