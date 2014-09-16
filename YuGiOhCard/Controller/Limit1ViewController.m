#import "Limit1ViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import "CardViewController.h"

@interface Limit1ViewController ()

@property (strong, nonatomic) IBOutlet NSMutableArray * _cards;

@end

@implementation Limit1ViewController

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
    self._cards = [DatabaseUtils queryLimit1Cards];
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
