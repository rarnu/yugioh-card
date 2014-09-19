#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "CardConsts.h"

// TODO: search conditions

@interface SearchViewController () {
    CardAttributePicker * picker;
    UIBarButtonItem * searchButton;
    UIBarButtonItem * cancelButton;
}

@end

@implementation SearchViewController

#pragma mark - view

-(void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"YuGiOh";
    searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick:)];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClick:)];
    self.navigationItem.rightBarButtonItems = @[cancelButton, searchButton];
    [self resetData];
}


-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - data
-(void) resetData {
    self.txtCardName.text = @"";
    self.txtCamp.text = [CardConsts campDefault];
    self.txtCardType.text = [CardConsts cardTypeDefault];
    self.txtSubtype.text = [CardConsts cardSubTypeDefault];
    [self.view endEditing:YES];
}

-(void) setEditMode: (BOOL) inEditing {
    [searchButton setEnabled:!inEditing];
    [cancelButton setEnabled:!inEditing];
    
    [self.txtCardName setEnabled:!inEditing];
    [self.txtCamp setEnabled:!inEditing];
    [self.txtCardType setEnabled:!inEditing];
    [self.txtSubtype setEnabled:!inEditing];
    
}

#pragma mark - button selector

-(void) searchClick: (id) sender {
    [self.view endEditing:YES];
    [self pushViewController];
}

-(void) cancelClick: (id) sender {
    [self resetData];
}

-(void) pushViewController {
    SearchResultViewController * resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultViewController"];
    [resultViewController setSearchCardName:self.txtCardName.text];
    [resultViewController setSearchCamp:self.txtCamp.text];
    [resultViewController setSearchCardType:self.txtCardType.text];
    [resultViewController setSearchSubType:self.txtSubtype.text];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

#pragma mark - text field

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentTv = textField;
    if (textField.tag == 0) {
        return YES;
    } else {
        [self popupPicker:textField];
        [self setEditMode: YES];
        return NO;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textFieldView{
    self.currentTv = nil;
}

#pragma mark - picker

-(void) pickDone:(NSString *)picked textField:(UITextField *)textField {
    textField.text = picked;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=picker.frame;
        rectSelectDate.origin.y=self.view.frame.size.height;
        picker.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        [picker removeFromSuperview];
        [self setEditMode:NO];
        finished = YES;
    }];
    
}

-(void) popupPicker: (UITextField *) textField {
    NSInteger rw = (self.view.frame.size.width * 0.8);
    NSInteger left = (self.view.frame.size.width - rw)/2;
    picker = [[CardAttributePicker alloc] initWithFrame:CGRectMake(left, self.view.frame.size.height, rw, 266)];
    [picker setTitle:textField.placeholder];
    [picker setTxtResult:textField];
    switch (textField.tag) {
        case 1: // camp
            [picker setPickObjects:[CardConsts campList]];
            break;
        case 2: // card type
            [picker setPickObjects:[CardConsts cardTypeList]];
            break;
        case 3: // monster type
            [picker setPickObjects:[CardConsts cardSubTypeList]];
            break;
        default:
            break;
    }

    NSString * current = textField.text;
    if ([current isEqualToString:@""]) {
        [picker selectFirst];
    } else {
        [picker selectCurrent:current];
    }
    picker.delegate = self;
    [self.view addSubview:picker];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=picker.frame;
        rectSelectDate.origin.y=(self.view.frame.size.height-picker.frame.size.height)/2;
        picker.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        [textField setEnabled:NO];
        finished = YES;
    }];
}

#pragma mark - keyboard

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
