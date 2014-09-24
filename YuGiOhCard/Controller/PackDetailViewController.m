#import "PackDetailViewController.h"
#import "UrlConsts.h"
#import "FileUtils.h"
#import "PackItem.h"
#import "DatabaseUtils.h"
#import "CardViewController.h"

@interface PackDetailViewController () {
    NSString * _packages;
    NSString * _data_path;
    PackageCards * _pack_cards;
    NSMutableArray * _cards;
}

@end

@implementation PackDetailViewController

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
    _packages = [NSString stringWithFormat:@"%@.pkg", self.packageId];
    _data_path = @"data";
    _pack_cards = [[PackageCards alloc] init];
    _cards = [[NSMutableArray alloc] init];
    NSString * jsonData = [FileUtils readTextFile:_packages loadPath:_data_path];
    if ([jsonData isEqualToString:@""]) {
        HttpUtils * hu = [HttpUtils alloc];
        hu.delegate = self;
        NSString * packageCardUrl = [NSString stringWithFormat:URL_PACAKGE_CARD, self.packageId];
        [hu get:packageCardUrl];
    } else {
        [self loadData:jsonData];
    }
    
    [self.refreshButton setTarget:self];
    [self.refreshButton setAction:@selector(refreshClicked:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - action

-(void) refreshClicked: (id) sender {
    HttpUtils * hu = [HttpUtils alloc];
    hu.delegate = self;
    NSString * packageCardUrl = [NSString stringWithFormat:URL_PACAKGE_CARD, self.packageId];
    [hu get:packageCardUrl];
}

#pragma mark -http

-(void) httpUtils:(HttpUtils *)httpUtils receivedData:(NSData *)data {
    if (data != nil) {
        NSString * json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [FileUtils writeTextFile:_packages savePath:_data_path fileContent:json];
        [self loadData:json];
    }
}

-(void) httpUtils:(HttpUtils *)httpUtils receivedError:(NSString *)err {
    
}

-(void) loadData: (NSString *) json {
    NSData * data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id pack = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    _pack_cards.name = pack[@"name"];
    [_pack_cards.cards removeAllObjects];
    [_pack_cards.cards addObjectsFromArray:pack[@"cards"]];
    _cards = [DatabaseUtils queryCardsViaIds:_pack_cards.cards];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CardItem * item = _cards[indexPath.row];
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
        CardItem * item = _cards[[self.tableView indexPathForSelectedRow].row];
        [[segue destinationViewController] setCardId:item.card_id];
        [[segue destinationViewController] setCardName:item.name];
    }
}


@end
