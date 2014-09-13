#import "SearchViewController.h"
#import "SearchResultViewController.h"

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
    SearchResultViewController * resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultViewController"];
    [resultViewController setSearchCardName:self.txtCardName.text];
    [self.navigationController pushViewController:resultViewController animated:YES];

}

-(void) textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"end editing");
}

@end
