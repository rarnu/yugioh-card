#import "FeedbackViewController.h"
#import "HttpUtils.h"
#import "UrlConsts.h"
#import "StringConsts.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = RIGHT_MENU_FEEDBACK;
    [self.txtFeedback becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction) sendClicked:(id)sender {
    [self.view endEditing:YES];
    NSString * _appver = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString * appver = [_appver stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * _txt = self.txtFeedback.text;
    NSString * txt = [_txt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIDevice * dev = [UIDevice currentDevice];
    NSString * osver = [dev systemVersion];
    NSString * osname = [dev systemName];
    NSString * _osstr = [NSString stringWithFormat:@"%@ (%@)", osname, osver];
    NSString * osstr = [_osstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * _uuid = [dev identifierForVendor].UUIDString;
    NSString * uuid = [_uuid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString * param = [NSString stringWithFormat:PARAM_FEEDBACK, uuid, @"", txt, appver, osstr];
    HttpUtils * hu = [HttpUtils alloc];
    [hu get:[NSString stringWithFormat:@"%@?%@", URL_FEEDBACK, param]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
