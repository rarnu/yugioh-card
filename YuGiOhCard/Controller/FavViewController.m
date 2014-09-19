#import "FavViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import "CardViewController.h"
#import "StringConsts.h"

@interface FavViewController () {
    UILabel * lblNoCard;
}

@property (strong, nonatomic) NSMutableArray * _cards;

@end

@implementation FavViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    NSMutableArray * ids = [DatabaseUtils favQuery];
    self._cards = [DatabaseUtils queryCardsViaIds:ids];
    [self.tableView reloadData];
    if (self._cards.count == 0) {
        [lblNoCard setHidden:NO];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [lblNoCard setHidden:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger lblTop = (self.tableView.frame.size.height - 100)/2;
    lblNoCard = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTop, self.tableView.frame.size.width, 50)];
    lblNoCard.text = STR_NO_CARD_COLLECTED;
    lblNoCard.textColor = [UIColor whiteColor];
    lblNoCard.backgroundColor = [UIColor clearColor];
    lblNoCard.textAlignment = NSTextAlignmentCenter;
    [lblNoCard setHidden:YES];
    [self.tableView addSubview:lblNoCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CardItem * item = self._cards[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.sCardType;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushCard"]) {
        CardItem * item = self._cards[[self.tableView indexPathForSelectedRow].row];
        [[segue destinationViewController] setCardId:item.card_id];
        [[segue destinationViewController] setCardName:item.name];
    }
}

@end
