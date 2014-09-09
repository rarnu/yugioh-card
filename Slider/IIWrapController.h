#import <UIKit/UIKit.h>

@interface IIWrapController : UIViewController

@property (nonatomic, readonly, retain) UIViewController* wrappedController;
@property (nonatomic, copy) void(^onViewDidLoad)(IIWrapController* controller);
@property (nonatomic, copy) void(^onViewWillAppear)(IIWrapController* controller, BOOL animated);
@property (nonatomic, copy) void(^onViewDidAppear)(IIWrapController* controller, BOOL animated);
@property (nonatomic, copy) void(^onViewWillDisappear)(IIWrapController* controller, BOOL animated);
@property (nonatomic, copy) void(^onViewDidDisappear)(IIWrapController* controller, BOOL animated);

- (id)initWithViewController:(UIViewController*)controller;

@end

// category on WrappedController to provide access to the viewDeckController in the 
// contained viewcontrollers, a la UINavigationController.
@interface UIViewController (WrapControllerItem) 

@property(nonatomic,readonly,assign) IIWrapController *wrapController; 

@end
