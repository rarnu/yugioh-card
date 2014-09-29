#import "AboutView.h"
#import "ApplicationUtils.h"
#import "StringConsts.h"

@implementation AboutView
@synthesize lblVersion;
@synthesize lblPublic;

-(id) init {
    NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"AboutView" owner:nil options:nil];
    self = [nibs objectAtIndex:0];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
        CGSize size = [ApplicationUtils getApplicationSize];
        float cx = size.width / 2;
        float cy = size.height / 2;
        [self setCenter:CGPointMake(cx, cy)];
        [self setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
        [self fillData];
    }
    return self;
}

-(void) fillData {
    self.lblVersion.text = [NSString stringWithFormat:@"ver %@ (%@)", [ApplicationUtils getAppVersion], [ApplicationUtils getAppBuild]];
    self.lblPublic.text = [NSString stringWithFormat:STR_PUBLIC_DATE, [ApplicationUtils getPublicDate]];
}

-(void) tapped: (id) sender {
    if ([self.delegate respondsToSelector:@selector(aboutview:tapped:)]) {
        [self.delegate aboutview:self tapped:YES];
    }
}

@end
