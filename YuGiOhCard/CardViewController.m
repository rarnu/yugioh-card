#import "CardViewController.h"
#import "DatabaseUtils.h"

@interface CardViewController ()

@end

@implementation CardViewController

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
    self.title = self.cardName;
    self.card = [DatabaseUtils queryOneCard:self.cardId];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStyleBordered target:self action:@selector(likeClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) likeClicked:(id)sender {
    // NSLog([NSString stringWithFormat:@"Like Clicked: %@", self.card.name]);
}

@end
