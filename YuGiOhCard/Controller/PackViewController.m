#import "PackViewController.h"
#import "FileUtils.h"
#import "UrlConsts.h"
#import "PackItem.h"
#import "PackDetailViewController.h"

@interface PackViewController () {
    NSString * _packages;
    NSString * _data_path;
    NSInteger _section_count;
    NSMutableArray * _pack_section;
}

@end

@implementation PackViewController

#pragma mark - view

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
    _packages = @"packages";
    _data_path = @"data";
    _pack_section = [[NSMutableArray alloc] init];
    NSString * jsonData = [FileUtils readTextFile:_packages loadPath:_data_path];
    if ([jsonData isEqualToString:@""]) {
        HttpUtils * hu = [HttpUtils alloc];
        hu.delegate = self;
        [hu get:URL_PACKAGES];
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
    [hu get:URL_PACKAGES];
}

#pragma mark - http

-(void) httpUtils:(HttpUtils *)httpUtils receivedData:(NSData *)data {
    if (data != nil) {
        NSString * json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [FileUtils writeTextFile:_packages savePath:_data_path fileContent:json];
        [self loadData:json];
    }
}

-(void) httpUtils:(HttpUtils *)httpUtils receivedError:(NSString *)err {
    
}

-(void) loadData: (NSString *) jsonData {
    // load json data
    NSData * data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * packs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    id pack = nil;
    NSArray * arrPack;
    id packDetail = nil;
    for (NSInteger i=0; i<packs.count; i++) {
        pack = packs[i];
        PackItem * item = [[PackItem alloc] init];
        item.serial = pack[@"serial"];
        arrPack = pack[@"packages"];
        for (NSInteger j=0; j<arrPack.count; j++) {
            packDetail = arrPack[j];
            [item.packages addObject:[[PackageDetail alloc] initWithId:packDetail[@"id"] packName:packDetail[@"packname"]]];
        }
        [_pack_section addObject:item];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _pack_section.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((PackItem *)_pack_section[section]).packages.count;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * lblSection = [[UILabel alloc] init];
    lblSection.text = [@"  " stringByAppendingString: ((PackItem *)_pack_section[section]).serial];
    lblSection.textColor = [UIColor whiteColor];
    lblSection.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    return lblSection;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PackageDetail * item = ((PackItem *)_pack_section[indexPath.section]).packages[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = item.packName;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushPack"]) {
        NSIndexPath * index = [self.tableView indexPathForSelectedRow];
        PackageDetail * item = ((PackItem *)_pack_section[index.section]).packages[index.row];
        [[segue destinationViewController] setPackageId:item.packId];
    }
}


@end
