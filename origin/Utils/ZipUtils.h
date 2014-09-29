#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@class ZipUtils;

@protocol ZipUtilsDelegate <NSObject>

@optional
-(BOOL) zipWillUnzip;
-(void) ziputils: (ZipUtils *) ziputils unzipCompleted: (BOOL) succ;

@end

@interface ZipUtils : NSObject

@property id<ZipUtilsDelegate> delegate;
@property (nonatomic) NSString * archiveFile;
@property (nonatomic) NSString * extractPath;

-(void) unzip;

@end
