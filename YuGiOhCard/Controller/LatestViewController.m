#import "LatestViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import "CardViewController.h"

@interface LatestViewController ()

@property (strong, nonatomic) NSMutableArray * _cards;

@end

@implementation LatestViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._cards = [DatabaseUtils queryLast100];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
