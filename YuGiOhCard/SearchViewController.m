#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"YuGiOh";
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick:)];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClick:)];
    self.navigationItem.rightBarButtonItems = @[cancelButton, searchButton];
}

-(void) searchClick: (id) sender {
    [self pushViewController];
}

-(void) cancelClick: (id) sender {
    
}

-(void) pushViewController {
    UIViewController * resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultViewController"];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end
