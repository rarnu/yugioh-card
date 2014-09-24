#import "RootViewController.h"
#import "LeftMenuViewController.h"
#import "ConfigUtils.h"

@interface RootViewController ()

@end

@implementation RootViewController

static RootViewController * _instance = nil;

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.contentViewScaleValue = 0.9f;
    self.scaleContentView = FALSE;
    self.scaleMenuView = FALSE;
    self.scaleBackgroundImageView = FALSE;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    NSString * background_name = [ConfigUtils loadBackgroundImage];
    if (background_name == nil || [background_name isEqualToString:@""]) {
        background_name = @"bg1";
    }
    self.backgroundImage = [UIImage imageNamed:background_name];
    self.delegate = self;
    _instance = self;
}

+(RootViewController *) getInstance {
    return _instance;
}

#pragma mark - RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
}

@end
