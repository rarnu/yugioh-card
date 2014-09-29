#import "ToolViewController.h"
#import "DiceView.h"
#import "CoinView.h"

@interface ToolViewController () {
    int player1Life;
    int player2Life;
    
    DiceView * dice;
    CoinView * coin;
}

@end

@implementation ToolViewController

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
    player1Life = 8000;
    player2Life = 8000;
    self.txt1Life.layer.borderWidth = 0.5;
    self.txt1Life.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.txt2Life.layer.borderWidth = 0.5;
    self.txt2Life.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self showLife];
}

-(void) showLife {
    self.lbl1Life.text = [NSString stringWithFormat:@"%d", player1Life];
    self.lbl2Life.text = [NSString stringWithFormat:@"%d", player2Life];
    self.txt1Life.text = @"";
    self.txt2Life.text = @"";
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - delegate
-(void) doneDice {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=dice.frame;
        rectSelectDate.origin.y=rect.size.height;
        dice.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        [dice removeFromSuperview];
        [self.btnCoin setEnabled:YES];
        [self.btnDice setEnabled:YES];
        finished = YES;
    }];
}

-(void) doneCoin {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=coin.frame;
        rectSelectDate.origin.y=rect.size.height;
        coin.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        [coin removeFromSuperview];
        [self.btnCoin setEnabled:YES];
        [self.btnDice setEnabled:YES];
        finished = YES;
    }];
}

#pragma mark -actions

-(IBAction)btnDiceClick:(id)sender {

    CGRect rect = [UIScreen mainScreen].applicationFrame;
    NSInteger rw = (rect.size.width * 0.8);
    NSInteger left = (rect.size.width - rw)/2;
    dice = [[DiceView alloc] initWithFrame:CGRectMake(left, rect.size.height, rw, 266)];
    dice.delegate = self;
    
    [self.view addSubview:dice];
    [self.btnDice setEnabled:NO];
    [self.btnCoin setEnabled:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=dice.frame;
        rectSelectDate.origin.y=(rect.size.height-dice.frame.size.height)/2;
        dice.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        finished = YES;
    }];
}

-(IBAction)btnCoinClick:(id)sender {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    NSInteger rw = (rect.size.width * 0.8);
    NSInteger left = (rect.size.width - rw)/2;
    coin = [[CoinView alloc] initWithFrame:CGRectMake(left, rect.size.height, rw, 266)];
    coin.delegate = self;
    
    [self.view addSubview:coin];
    [self.btnDice setEnabled:NO];
    [self.btnCoin setEnabled:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=coin.frame;
        rectSelectDate.origin.y=(rect.size.height-coin.frame.size.height)/2;
        coin.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        finished = YES;
    }];
}

-(IBAction)resetClick:(id)sender {
    player1Life = 8000;
    player2Life = 8000;
    [self showLife];
}

-(IBAction)btn1AddClick:(id)sender {
    int lifeDelta = [self.txt1Life.text intValue];
    player1Life += lifeDelta;
    [self showLife];
}

-(IBAction)btn1MinusClick:(id)sender {
    int lifeDelta = [self.txt1Life.text intValue];
    player1Life -= lifeDelta;
    if (player1Life < 0) {
        player1Life = 0;
    }
    [self showLife];
}

-(IBAction)btn1SetClick:(id)sender {
    int lifeDelta = [self.txt1Life.text intValue];
    player1Life = lifeDelta;
    [self showLife];
    
}
-(IBAction)btn1HalfClick:(id)sender {
    player1Life /= 2;
    [self showLife];
}

-(IBAction)btn1DoubleClick:(id)sender {
    player1Life *= 2;
    [self showLife];
}

-(IBAction)btn1BalanceClick:(id)sender {
    int life = (player1Life + player2Life) / 2;
    player1Life = life;
    player2Life = life;
    [self showLife];
}

-(IBAction)btn1EqualClick:(id)sender {
    player1Life = player2Life;
    [self showLife];
}

-(IBAction)btn2AddClick:(id)sender {
    int lifeDelta = [self.txt2Life.text intValue];
    player2Life += lifeDelta;
    [self showLife];
}

-(IBAction)btn2MinusClick:(id)sender {
    int lifeDelta = [self.txt2Life.text intValue];
    player2Life -= lifeDelta;
    [self showLife];
}

-(IBAction)btn2SetClick:(id)sender {
    int lifeDelta = [self.txt2Life.text intValue];
    player2Life = lifeDelta;
    [self showLife];
    
}
-(IBAction)btn2HalfClick:(id)sender {
    player2Life /= 2;
    [self showLife];
}

-(IBAction)btn2DoubleClick:(id)sender {
    player2Life *= 2;
    [self showLife];
}

-(IBAction)btn2BalanceClick:(id)sender {
    int life = (player1Life + player2Life) / 2;
    player1Life = life;
    player2Life = life;
    [self showLife];
}

-(IBAction)btn2EqualClick:(id)sender {
    player2Life = player1Life;
    [self showLife];
}

@end
