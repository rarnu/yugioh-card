#import "CardAdjustViewController.h"
#import "CardViewController.h"
#import "CardItem.h"

@interface CardAdjustViewController ()

@property (nonatomic) CardItem * card;

@end

@implementation CardAdjustViewController

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
    NSString * str = [NSString stringWithFormat:@"%@\n\n\n\n", self.card.adjust];
    self.txtAdjust.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
