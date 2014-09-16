#import "CardPicViewController.h"
#import "CardViewController.h"
#import "CardItem.h"
#import "FileUtils.h"
#import "UrlConsts.h"

@interface CardPicViewController () {
    NSString * _img_path;
}

@property (nonatomic) CardItem * card;

@end

@implementation CardPicViewController

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
    _img_path = @"image";
    self.card = ((CardViewController *)self.tabBarController).card;
    NSString * cardImgName = [NSString stringWithFormat:@"%ld.jpg", (long)self.card.card_id];
    BOOL exists = [FileUtils fileExists:cardImgName filePath:_img_path];
    if (exists) {
        [self loadImage:[FileUtils readFile:cardImgName loadPath:_img_path]];
    } else {
        [self.imgCard setHidden:YES];
        [self.btnDownload setHidden:NO];
        [self.aivDownload setHidden:YES];
        [self.btnDownload addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) downloadClick:(id)sender {
    [self.aivDownload setHidden:NO];
    [self.btnDownload setHidden:YES];
    HttpUtils * hu = [HttpUtils alloc];
    hu.delegate = self;
    NSString * url = [NSString stringWithFormat:URL_CARD_IMAGE, (long)self.card.card_id];
    [hu get:url];
}

-(void) receivedData:(NSData *)data {
    if (data != nil) {
        NSString * fileName = [NSString stringWithFormat:@"%ld.jpg", (long)self.card.card_id];
        [FileUtils writeFile:fileName savePath:_img_path fileData:data];
        [self loadImage: data];
    }
}

-(void) receivedError:(NSString *)err {
    [self.imgCard setHidden:YES];
    [self.btnDownload setHidden:NO];
    [self.aivDownload setHidden:YES];
}

-(void) loadImage: (NSData *) data {
    [self.imgCard setHidden:NO];
    [self.btnDownload setHidden:YES];
    [self.aivDownload setHidden:YES];
    [self.imgCard setImage:[UIImage imageWithData:data]];
}

@end
