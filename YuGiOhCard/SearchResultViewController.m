#import "SearchResultViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import <sqlite3.h>
#import "CardViewController.h"

@interface SearchResultViewController ()

@property (strong, nonatomic) NSMutableArray * _cards;

@end

@implementation SearchResultViewController

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
    self.navigationItem.title = @"Result";
    self._cards = [DatabaseUtils queryData:@"select _id, id, name, sCardType from YGODATA where id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,6483)"];
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
