#import "SearchResultViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import <sqlite3.h>
#import "CardViewController.h"
#import "CardConsts.h"

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
    NSString * sql = [self buildSql];
    self._cards = [DatabaseUtils queryData:sql];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - sql
-(NSString *) buildSql {
    NSString * sql = @"select _id, id, name, sCardType from YGODATA where 1=1";
    // name
    if (![self.searchCardName isEqualToString:@""]) {
        sql = [sql stringByAppendingFormat:@" and (name like '%%%%%@%%%%' or japName like '%%%%%@%%%%' or enName like '%%%%%@%%%%' or shortName like '%%%%%@%%%%' or oldName like '%%%%%@%%%%')", self.searchCardName, self.searchCardName,self.searchCardName, self.searchCardName, self.searchCardName];
    }
    // camp
    if (![self.searchCamp isEqualToString:@""] && ![self.searchCamp isEqualToString:[CardConsts campDefault]]) {
        sql = [sql stringByAppendingFormat:@" and cardCamp='%@'", self.searchCamp];
    }
    // card type
    if (![self.searchCardType isEqualToString:@""] && ![self.searchCardType isEqualToString:[CardConsts cardTypeDefault]]) {
        sql = [sql stringByAppendingFormat:@" and sCardType like '%%%%%@%%%%'", self.searchCardType];
        if ([self.searchCardType rangeOfString:[CardConsts cardMonsterDefault]].location != NSNotFound) {
            // sub type
            if (![self.searchSubType isEqualToString:@""] && ![self.searchSubType isEqualToString:[CardConsts cardSubTypeDefault]]) {
                sql = [sql stringByAppendingFormat:@" and CardDType like '%%%%%@%%%%'", self.searchSubType];
            }
        }
    }
    return sql;
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
