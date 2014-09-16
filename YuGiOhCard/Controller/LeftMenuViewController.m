#import "LeftMenuViewController.h"
#import "SearchViewController.h"
#import "UIViewController+RESideMenu.h"

@interface LeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray * controllerNames;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controllerNames = @[@"searchViewController", @"limitViewController", @"latestViewController", @"packViewController", @"favViewController", @"toolViewController"];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 6) / 2.0f, self.view.frame.size.width, 54 * 6) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:self.controllerNames[indexPath.row]]] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: rebuild here
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"卡片搜索", @"禁限卡表", @"最新卡片", @"卡包", @"我的最爱", @"决斗工具"];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

@end
