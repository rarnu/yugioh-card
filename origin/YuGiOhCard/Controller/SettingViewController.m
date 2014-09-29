#import "SettingViewController.h"
#import "StringConsts.h"
#import "ConfigUtils.h"
#import "RootViewController.h"
#import "FileUtils.h"

@interface UIBackgroundImageCell()

@end

@implementation UIBackgroundImageCell

@end


@interface SettingViewController () {
    NSMutableArray * _backgrounds;
    CGSize _grid_size;
    NSString * _current_background;
    NSString * _document;
    NSFileManager * fmgr;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = RIGHT_MENU_SETTING;
    _grid_size = [self generateImageSize];
    _current_background = [ConfigUtils loadBackgroundImage];
    if (_current_background == nil || [_current_background isEqualToString:@""]) {
        _current_background = @"bg1";
    }
    
    _backgrounds = [[NSMutableArray alloc] init];
    for (int i=1; i<=9; i++) {
        [_backgrounds addObject:[NSString stringWithFormat:@"bg%d", i]];
    }
    _document = [FileUtils getDocumentPath];
    fmgr = [NSFileManager defaultManager];
    NSString * sizeStr = [NSString stringWithFormat:@"%.2f M", [FileUtils folderSizeAtPath:_document]];
    [self.btnSpace setTitle:sizeStr forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - action
-(IBAction)cleanClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:STR_CONFIRM message:STR_CONFIRM_CLEAR_DOCUMENT delegate:self cancelButtonTitle:COMMON_CANCEL otherButtonTitles:COMMON_OK, nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"button clicked: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 1:
            [self removeDocumentFiles];
            [self.btnSpace setTitle:[NSString stringWithFormat:@"%.2f M", [FileUtils folderSizeAtPath:_document]] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - file

-(void) removeDocumentFiles {
    NSString * imgPath = [_document stringByAppendingPathComponent:@"image"];
    [fmgr removeItemAtPath:imgPath error:nil];
    if (![fmgr fileExistsAtPath:imgPath]) {
        [fmgr createDirectoryAtPath:imgPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - collection view delegate

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _backgrounds.count;
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIBackgroundImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imgName = _backgrounds[indexPath.row];
    [cell.img setImage:[UIImage imageNamed:_backgrounds[indexPath.row]]];
    [cell.selectMark setHidden:![_current_background isEqualToString:cell.imgName]];
    return cell;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    _current_background = _backgrounds[indexPath.row];
    [ConfigUtils saveBackgroundImage:_current_background];
    RootViewController * root = [RootViewController getInstance];
    if (root) {
        root.backgroundImage = [UIImage imageNamed:_current_background];
    }
    [collectionView reloadData];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _grid_size;
}

-(CGSize) generateImageSize {
    return CGSizeMake(89, 166);
}

@end
