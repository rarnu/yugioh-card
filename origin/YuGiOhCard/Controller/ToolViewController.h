#import <UIKit/UIKit.h>
#import "CoinView.h"
#import "DiceView.h"

@interface ToolViewController : UIViewController<CoinDelegate, DiceDelegate>

// global
@property (strong, nonatomic) IBOutlet UIBarButtonItem * resetButton;
@property (strong, nonatomic) IBOutlet UILabel * lbl1Life;
@property (strong, nonatomic) IBOutlet UILabel * lbl2Life;
@property (strong, nonatomic) IBOutlet UIButton * btnDice;
@property (strong, nonatomic) IBOutlet UIButton * btnCoin;

// player1
@property (strong, nonatomic) IBOutlet UITextField * txt1Life;
@property (strong, nonatomic) IBOutlet UIButton * btn1Add;
@property (strong, nonatomic) IBOutlet UIButton * btn1Minus;
@property (strong, nonatomic) IBOutlet UIButton * btn1Set;
@property (strong, nonatomic) IBOutlet UIButton * btn1Half;
@property (strong, nonatomic) IBOutlet UIButton * btn1Double;
@property (strong, nonatomic) IBOutlet UIButton * btn1Balance;
@property (strong, nonatomic) IBOutlet UIButton * btn1Equal;

// player2
@property (strong, nonatomic) IBOutlet UITextField * txt2Life;
@property (strong, nonatomic) IBOutlet UIButton * btn2Add;
@property (strong, nonatomic) IBOutlet UIButton * btn2Minus;
@property (strong, nonatomic) IBOutlet UIButton * btn2Set;
@property (strong, nonatomic) IBOutlet UIButton * btn2Half;
@property (strong, nonatomic) IBOutlet UIButton * btn2Double;
@property (strong, nonatomic) IBOutlet UIButton * btn2Balance;
@property (strong, nonatomic) IBOutlet UIButton * btn2Equal;

// actions
-(IBAction)resetClick:(id)sender;
-(IBAction)btnDiceClick:(id)sender;
-(IBAction)btnCoinClick:(id)sender;

-(IBAction)btn1AddClick:(id)sender;
-(IBAction)btn1MinusClick:(id)sender;
-(IBAction)btn1SetClick:(id)sender;
-(IBAction)btn1HalfClick:(id)sender;
-(IBAction)btn1DoubleClick:(id)sender;
-(IBAction)btn1BalanceClick:(id)sender;
-(IBAction)btn1EqualClick:(id)sender;

-(IBAction)btn2AddClick:(id)sender;
-(IBAction)btn2MinusClick:(id)sender;
-(IBAction)btn2SetClick:(id)sender;
-(IBAction)btn2HalfClick:(id)sender;
-(IBAction)btn2DoubleClick:(id)sender;
-(IBAction)btn2BalanceClick:(id)sender;
-(IBAction)btn2EqualClick:(id)sender;

@end
