#import "CardViewController.h"
#import "DatabaseUtils.h"

@interface CardViewController () {
    UIBarButtonItem * likeButton;
    UIBarButtonItem * unlikeButton;
}

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
    likeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(likeClicked:)];
    unlikeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(unlikeClicked:)];
    BOOL isFav = [DatabaseUtils favExists:self.cardId];
    self.navigationItem.rightBarButtonItem = isFav?unlikeButton:likeButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) likeClicked:(id)sender {
    [DatabaseUtils favAdd:self.cardId];
    self.navigationItem.rightBarButtonItem = unlikeButton;
}

-(void) unlikeClicked: (id) sender {
    [DatabaseUtils favRemove:self.cardId];
    self.navigationItem.rightBarButtonItem = likeButton;
}

@end
