#import "UpdateViewController.h"
#import "StringConsts.h"
#import "UrlConsts.h"
#import "DatabaseUtils.h"
#import "ApplicationUtils.h"

@interface UpdateViewController () {
    long long _update_file_size;
}

@end

@implementation UpdateViewController

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
    self.title = RIGHT_MENU_UPDATE;
    [self.procDownload setHidden:YES];
    [self.btnUpdate setEnabled:NO];
    HttpUtils * hu = [HttpUtils alloc];
    int build = [[ApplicationUtils getAppBuild] intValue];
    int lastCard = [DatabaseUtils queryLastCardId] -1 ;
    int dbver = [DatabaseUtils getDatabaseVersion];
    NSString * param = [NSString stringWithFormat:PARAM_UPDATE, build, lastCard, dbver];
    hu.tag = 1;
    hu.delegate = self;
    [hu get:[NSString stringWithFormat:@"%@?%@", URL_UPDATE, param]];
    self.lblCurrentCount.text = [NSString stringWithFormat:STR_CARD_COUNT, lastCard];
    self.lblNewCount.text = [NSString stringWithFormat:STR_CARD_COUNT, 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - http utils

-(void) httpUtils:(HttpUtils *)httpUtils receivedData:(NSData *)data {
    switch (httpUtils.tag) {
        case 1:
            [self extractUpdateInfo:data];
            break;
        case 2:
            break;
        default:
            break;
    }
}

-(void) httpUtils:(HttpUtils *)httpUtils receivedFileSize:(long long)fileSize {
    if (httpUtils.tag == 2) {
        _update_file_size = fileSize;
        [self.procDownload setHidden:NO];
    }
}
         
-(void) httpUtils:(HttpUtils *)httpUtils receivedProgress:(long long)progress {
    if (httpUtils.tag == 2) {
        float percent = progress / _update_file_size;
        [self.procDownload setProgress:percent];
    }
}

-(void) httpUtils:(HttpUtils *)httpUtils receivedError:(NSString *)err {
    
}

#pragma mark - action

-(IBAction)updateClicked:(id)sender {
    [self.btnUpdate setEnabled:NO];
    [self.procDownload setProgress:0];
    [self.procDownload setHidden:NO];
    HttpUtils * hu = [HttpUtils alloc];
    hu.tag = 2;
    hu.delegate = self;
    [hu get:URL_FILE_DATABASE];

}

#pragma mark - json

-(void) extractUpdateInfo: (NSData *) json {
    id info = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
    int newcard = [info[@"newcard"] intValue];
    if (newcard != 0) {
        [self.btnUpdate setTitle:STR_DOWNLOAD_UPDATE forState:UIControlStateNormal];
        [self.btnUpdate setEnabled:YES];
        self.lblNewCount.text = [NSString stringWithFormat:STR_CARD_COUNT, newcard];
    } else {
        [self.btnUpdate setTitle:STR_DOWNLOAD_NA forState:UIControlStateNormal];
        [self.btnUpdate setEnabled:NO];
    }
}

@end
