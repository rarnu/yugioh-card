#import "ZipUtils.h"

@implementation ZipUtils

-(void) unzip {
    [NSThread detachNewThreadSelector:@selector(doUncompress) toTarget:self withObject:nil];
    
}

-(void) doUncompress {
    if ([self.delegate respondsToSelector:@selector(zipWillUnzip)]) {
        if ([self.delegate zipWillUnzip]) {
            ZipArchive * za = [[ZipArchive alloc] init];
            NSNumber * ret = [NSNumber numberWithBool:NO];
            if ([za UnzipOpenFile:self.archiveFile]) {
                BOOL succ = [za UnzipFileTo:self.extractPath overWrite:YES];
                [za UnzipCloseFile];
                ret = [NSNumber numberWithBool:succ];
            }
            [self performSelectorOnMainThread:@selector(callback:) withObject:ret waitUntilDone:YES];
        }
    }
}

-(void)callback: (NSNumber *) ret {
    if ([self.delegate respondsToSelector:@selector(ziputils:unzipCompleted:)]) {
        [self.delegate ziputils:self unzipCompleted:[ret boolValue]];
    }
}

@end
