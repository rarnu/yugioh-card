#import "CoinView.h"
#import "StringConsts.h"

@interface CoinView() {
    UILabel * toolTitle;
    UIButton * toolButton;
}

@end

@implementation CoinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self makeUI];
}

-(void) makeUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    self.toolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.toolbar.frame.size.width-50, self.toolbar.frame.size.height)];
    toolTitle.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [toolTitle setText:TOOL_COIN];
    [self.toolbar addSubview:toolTitle];
    
    toolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    toolButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [toolButton setFrame:CGRectMake(self.toolbar.frame.size.width-50, 0, 50, self.toolbar.frame.size.height)];
    [toolButton setTitle:COMMON_CLOSE forState:UIControlStateNormal];
    [toolButton addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchDown];
    [self.toolbar addSubview:toolButton];
    
    self.btnRefresh = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnRefresh setFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [self.btnRefresh setTitle:COMMON_REFRESH forState:UIControlStateNormal];
    [self.btnRefresh addTarget:self action:@selector(refreshClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.toolbar];
    [self addSubview:self.btnRefresh];
}

-(void) closeClicked: (id) sender {
    if ([self.delegate respondsToSelector:@selector(doneCoin)]) {
        [self.delegate doneCoin];
    }
}

-(void) refreshClicked: (id) sender {
    
}

@end
