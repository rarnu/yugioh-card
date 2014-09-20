#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "CardConsts.h"

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
    
    if (self.pushView != nil && ![self.pushView isEqualToString:@""]) {
        UIViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:self.pushView];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
}

#pragma mark - data
-(void) resetData {
    self.txtCardName.text = @"";
    self.txtCamp.text = [CardConsts campDefault];
    self.txtCardType.text = [CardConsts cardTypeDefault];
    self.txtSubtype.text = [CardConsts cardSubTypeDefault];
    self.txtRace.text = [CardConsts cardRaceDefault];
    self.txtAttribute.text = [CardConsts cardAttributeDefault];
    self.txtLevel.text = [CardConsts cardLevelDefault];
    self.txtRare.text = [CardConsts cardRareDefault];
    self.txtLimit.text = [CardConsts cardLimitDefault];
    self.txtAtk.text = @"";
    self.txtDef.text = @"";
    self.txtEffect.text = @"";

    [self.view endEditing:YES];
}

-(void) setEditMode: (BOOL) inEditing {
    [searchButton setEnabled:!inEditing];
    [cancelButton setEnabled:!inEditing];
    
    [self.txtCardName setEnabled:!inEditing];
    [self.txtCamp setEnabled:!inEditing];
    [self.txtCardType setEnabled:!inEditing];
    [self.txtSubtype setEnabled:!inEditing];
    [self.txtRace setEnabled:!inEditing];
    [self.txtAttribute setEnabled:!inEditing];
    [self.txtLevel setEnabled:!inEditing];
    [self.txtRare setEnabled:!inEditing];
    [self.txtLimit setEnabled:!inEditing];
    [self.txtAtk setEnabled:!inEditing];
    [self.txtDef setEnabled:!inEditing];
    [self.txtEffect setEnabled:!inEditing];
    
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
    [resultViewController setSearchRace:self.txtRace.text];
    [resultViewController setSearchAttribute:self.txtAttribute.text];
    [resultViewController setSearchLevel:self.txtLevel.text];
    [resultViewController setSearchRare:self.txtRare.text];
    [resultViewController setSearchLimit:self.txtLimit.text];
    [resultViewController setSearchAtk:self.txtAtk.text];
    [resultViewController setSearchDef:self.txtDef.text];
    [resultViewController setSearchEffect:self.txtEffect.text];
    
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
        [self.view endEditing:YES];
        [self setEditMode: YES];
        [self popupPicker:textField];
        return NO;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textFieldView{
    self.currentTv = nil;
}

#pragma mark - picker

-(void) pickDone:(NSString *)picked textField:(UITextField *)textField {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    textField.text = picked;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rectSelectDate=picker.frame;
        rectSelectDate.origin.y=rect.size.height;
        picker.frame=rectSelectDate;
    } completion:^(BOOL finished) {
        [picker removeFromSuperview];
        [self setEditMode:NO];
        finished = YES;
    }];
    
}

-(void) popupPicker: (UITextField *) textField {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    NSInteger rw = (rect.size.width * 0.8);
    NSInteger left = (rect.size.width - rw)/2;
    picker = [[CardAttributePicker alloc] initWithFrame:CGRectMake(left, rect.size.height, rw, 266)];
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
        case 4: // race
            [picker setPickObjects:[CardConsts cardRaceList]];
            break;
        case 5: // attribute
            [picker setPickObjects:[CardConsts cardAttributeList]];
            break;
        case 6: // level
            [picker setPickObjects:[CardConsts cardLevelList]];
            break;
        case 7: // rare
            [picker setPickObjects:[CardConsts cardRareList]];
            break;
        case 8: // limit
            [picker setPickObjects:[CardConsts cardLimitList]];
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
        rectSelectDate.origin.y=(rect.size.height-picker.frame.size.height)/2;
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
