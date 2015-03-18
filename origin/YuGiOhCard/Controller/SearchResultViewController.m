#import "SearchResultViewController.h"
#import "DatabaseUtils.h"
#import "CardItem.h"
#import <sqlite3.h>
#import "CardViewController.h"
#import "CardConsts.h"
#import "StringConsts.h"
#import "PushUtils.h"

@interface SearchResultViewController () {
    UILabel * lblNoCard;
}

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
    self.navigationItem.title = STR_RESULT;
    
    NSInteger lblTop = (self.tableView.frame.size.height - 100)/2;
    lblNoCard = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTop, self.tableView.frame.size.width, 50)];
    lblNoCard.text = STR_NO_CARD_FOUND;
    lblNoCard.textAlignment = NSTextAlignmentCenter;
    lblNoCard.textColor = [UIColor whiteColor];
    lblNoCard.backgroundColor = [UIColor clearColor];
    lblNoCard.hidden = YES;
    [self.tableView addSubview:lblNoCard];
    
    NSString * sql = [self buildSql];
    self._cards = [DatabaseUtils queryData:sql];
    if (self._cards.count == 0) {
        lblNoCard.hidden = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        lblNoCard.hidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - sql

-(NSString *) buildSql {
    NSString * sql = @"select _id, name, sCardType from YGODATA where 1=1";
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
    // attribute
    if (![self.searchAttribute isEqual:@""] && ![self.searchAttribute isEqualToString:[CardConsts cardAttributeDefault]]) {
        sql = [sql stringByAppendingFormat:@" and element='%@'", self.searchAttribute];
    }
    // race
    if (![self.searchRace isEqualToString:@""] && ![self.searchRace isEqualToString:[CardConsts cardRaceDefault]]) {
        sql = [sql stringByAppendingFormat:@" and tribe='%@'", self.searchRace];
    }
    // level
    if (![self.searchLevel isEqualToString:@""] && ![self.searchLevel isEqualToString:[CardConsts cardLevelDefault]]) {
        sql = [sql stringByAppendingFormat:@" and level=%@", self.searchLevel];
    }
    // rare
    if (![self.searchRare isEqualToString:@""] && ![self.searchRare isEqualToString:[CardConsts cardRareDefault]]) {
        sql = [sql stringByAppendingFormat:@" and infrequence like '%%%%%@%%%%'", self.searchRare];
    }
    // limit
    if (![self.searchLimit isEqualToString:@""] && ![self.searchLimit isEqualToString:[CardConsts cardLimitDefault]]) {
        sql = [sql stringByAppendingFormat:@" and ban='%@'", self.searchLimit];
    }
    // atk
    if (![self.searchAtk isEqualToString:@""]) {
        sql = [sql stringByAppendingFormat:@" and atk='%@'", self.searchAtk];
    }
    // def
    if (![self.searchDef isEqualToString:@""]) {
        sql = [sql stringByAppendingFormat:@" and def='%@'", self.searchDef];
    }
    // effect
    if (![self.searchEffect isEqualToString:@""]) {
        sql = [sql stringByAppendingFormat:@" and effect like '%%%%%@%%%%'", self.searchEffect];
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
    CardItem * item = self._cards[indexPath.row];
    [PushUtils pushCard:item navController:self.navigationController];
}


@end
