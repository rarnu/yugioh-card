#import "IIWrapController.h"

@interface IISideController : IIWrapController

@property (nonatomic, assign) CGFloat constrainedSize;

+ (IISideController*)autoConstrainedSideControllerWithViewController:(UIViewController*)controller;
+ (IISideController*)sideControllerWithViewController:(UIViewController*)controller constrained:(CGFloat)constrainedSize;

- (id)initWithViewController:(UIViewController*)controller constrained:(CGFloat)constrainedSize;

- (void)shrinkSide;
- (void)shrinkSideAnimated:(BOOL)animated;

@end


// category on UIViewController to provide access to the sideController in the
// contained viewcontrollers, a la UINavigationController.
@interface UIViewController (IISideController)

@property(nonatomic,readonly,retain) IISideController *sideController;

@end
