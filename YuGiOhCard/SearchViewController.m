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
    [self.view endEditing:YES];
    [self pushViewController];
}

-(void) cancelClick: (id) sender {
    
}

-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


-(void) pushViewController {
    SearchResultViewController * resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultViewController"];
    [resultViewController setSearchCardName:self.txtCardName.text];
    self.txtCardName.text = @"";
    [self.navigationController pushViewController:resultViewController animated:YES];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textFieldView{
    self.currentTv = textFieldView;
}

-(void)textFieldDidEndEditing:(UITextField *)textFieldView{
    self.currentTv = nil;
}

-(void)keyboardDidShow:(NSNotification *)notification{
    if (self.keyboardIsShown) {
        return;
    }
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.sv frame];
    viewFrame.size.height -= (keyboardRect.size.height);
    self.sv.frame = viewFrame;
    CGRect textFieldRect = [self.currentTv frame];
    [self.sv scrollRectToVisible:textFieldRect animated:NO];
    self.keyboardIsShown = YES;
}

-(void)keyboardDidHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.sv frame];
    viewFrame.size.height += keyboardRect.size.height;
    self.sv.frame = viewFrame;
    self.keyboardIsShown = NO;
}

@end
