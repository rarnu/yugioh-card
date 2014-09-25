#import "UpdateViewController.h"
#import "StringConsts.h"
#import "UrlConsts.h"
#import "DatabaseUtils.h"
#import "ApplicationUtils.h"
#import "FileUtils.h"
#import "DatabaseUtils.h"

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
    [self.btnUpdate setTitle:STR_DOWNLOAD_NA forState:UIControlStateNormal];
    [self.procDownload setHidden:YES];
    [self.btnUpdate setEnabled:NO];
    
    int build = [[ApplicationUtils getAppBuild] intValue];
    int lastCard = [DatabaseUtils queryLastCardId];
    int dbver = [DatabaseUtils getDatabaseVersion];
    NSString * param = [NSString stringWithFormat:PARAM_UPDATE, build, lastCard, dbver];
    HttpUtils * hu = [HttpUtils alloc];
    hu.tag = 1;
    hu.delegate = self;
    [hu get:[NSString stringWithFormat:@"%@?%@", URL_UPDATE, param]];
    self.lblCurrentCount.text = [NSString stringWithFormat:STR_CARD_COUNT, lastCard];
    self.lblNewCount.text = [NSString stringWithFormat:STR_CARD_COUNT, 0];
    // load update log
    HttpUtils * huLog = [[HttpUtils alloc] init];
    huLog.tag = 3;
    huLog.delegate = self;
    [huLog get:URL_UPDATE_LOG];
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
            [self uncompressData:data];
            break;
        case 3:
            [self showUpdateLog:data];
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

#pragma mark - data

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

-(void) uncompressData: (NSData *) data {
    [FileUtils writeFile:@"yugioh.zip" savePath:@"" fileData:data];
    ZipUtils * zu = [[ZipUtils alloc] init];
    NSString * archivePath = [[FileUtils getDocumentPath] stringByAppendingPathComponent:@"yugioh.zip"];
    zu.archiveFile = archivePath;
    zu.extractPath = [FileUtils getDocumentPath];
    zu.delegate = self;
    [zu unzip];
}

-(void) showUpdateLog: (NSData *) data {
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.tvLog.text = str;
}

#pragma mark - unzip
-(void) ziputils:(ZipUtils *)ziputils unzipCompleted:(BOOL)succ {
    [DatabaseUtils openDatabase];
    [self.btnUpdate setTitle:STR_DOWNLOAD_NA forState:UIControlStateNormal];
    [self.procDownload setHidden:YES];
    [self.btnUpdate setEnabled:NO];
    int lastCard = [DatabaseUtils queryLastCardId];
    self.lblCurrentCount.text = [NSString stringWithFormat:STR_CARD_COUNT, lastCard];
    self.lblNewCount.text = [NSString stringWithFormat:STR_CARD_COUNT, 0];
}

-(BOOL) zipWillUnzip {
    [DatabaseUtils closeDatabase];
    return YES;
}

@end
