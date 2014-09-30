#import "CardAttributePicker.h"
#import "StringConsts.h"

@interface CardAttributePicker() {
    UILabel * toolTitle;
    UIButton * toolButton;
}
@end

@implementation CardAttributePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        
    }
    return self;
}

-(void) makeUI {
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    self.toolbar.backgroundColor = [UIColor clearColor]; //[UIColor groupTableViewBackgroundColor];
    toolTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.toolbar.frame.size.width-50, self.toolbar.frame.size.height)];
    toolTitle.backgroundColor = [UIColor clearColor]; //[UIColor groupTableViewBackgroundColor];
    [self.toolbar addSubview:toolTitle];
    
    toolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    toolButton.backgroundColor = [UIColor clearColor]; //[UIColor groupTableViewBackgroundColor];
    [toolButton setFrame:CGRectMake(self.toolbar.frame.size.width-50, 0, 50, self.toolbar.frame.size.height)];
    [toolButton setTitle:COMMON_DONE forState:UIControlStateNormal];
    [toolButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchDown];
    [self.toolbar addSubview:toolButton];

    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 0)];
    self.picker.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.picker.showsSelectionIndicator = YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self addSubview:self.toolbar];
    [self addSubview:self.picker];
}

-(void) setTitle:(NSString *)title {
    [toolTitle setText:title];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 65536;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return pickerView.frame.size.height / 4;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString * title = self.pickObjects[row % self.pickObjects.count];
    UILabel * lblView = (UILabel *)view;
    if (!lblView) {
        lblView = [[UILabel alloc] init];
        [lblView setBackgroundColor:[UIColor clearColor]];
        [lblView setTextColor:[UIColor whiteColor]];
        [lblView setTextAlignment:NSTextAlignmentCenter];
        [lblView setFont:[UIFont boldSystemFontOfSize:24]];
    }
    [lblView setText:title];
    return lblView;
}

-(void) doneClick: (id) sender {
    NSString * picked = self.pickObjects[[self.picker selectedRowInComponent:0] % self.pickObjects.count];
    if ([self.delegate respondsToSelector:@selector(pickDone:textField:)]) {
        [self.delegate pickDone:picked textField:self.txtResult];
    }
}

-(void) selectFirst {
    NSInteger selected = (65536 / 2) - (65536 % self.pickObjects.count) - 1;
    [self.picker selectRow:selected inComponent:0 animated:NO];
}

-(void) selectCurrent:(NSString *)text {
    NSInteger selected = (65536 / 2) - (65536 % self.pickObjects.count) - 1;
    for (NSInteger i=selected; i<selected+self.pickObjects.count; i++) {
        if ([self.pickObjects[i % self.pickObjects.count] isEqualToString:text]) {
            [self.picker selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

@end