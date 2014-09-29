#import "FileUtils.h"

@implementation FileUtils

+(NSString *) getDocumentPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * document = [paths objectAtIndex:0];
    return document;
}

+(NSString *) makeDir: (NSString *) dir basePath: (NSString *) path {
    NSString * pathTmp = [path stringByAppendingPathComponent:dir];
    NSFileManager * fmgr = [NSFileManager defaultManager];
    if (![fmgr fileExistsAtPath:pathTmp]) {
        [fmgr createDirectoryAtPath:pathTmp withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return pathTmp;
}

+(void) writeTextFile:(NSString *)fileName savePath:(NSString *)path fileContent:(NSString *)text {
    NSString * document = [self getDocumentPath];
    NSString * pathTmp = [self makeDir:path basePath:document];
    NSString * fileOper = [pathTmp stringByAppendingPathComponent:fileName];
    NSData * writeData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [writeData writeToFile:fileOper atomically:YES];
}

+(NSString *) readTextFile:(NSString *)fileName loadPath:(NSString *)path {
    NSString * document = [self getDocumentPath];
    NSString * pathTemp = [document stringByAppendingPathComponent:path];
    NSString * fileOper = [pathTemp stringByAppendingPathComponent:fileName];
    
    NSString * text = @"";
    if ([self fileExists:fileName filePath:path]) {
        NSData * readData = [NSData dataWithContentsOfFile:fileOper];
        text = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    }
    
    return text;
}

+(void) writeFile:(NSString *)fileName savePath:(NSString *)path fileData:(NSData *)data {
    NSString * document = [self getDocumentPath];
    NSString * pathTmp = [self makeDir:path basePath:document];
    NSString * fileOper = [pathTmp stringByAppendingPathComponent:fileName];
    [data writeToFile:fileOper atomically:YES];
}

+(NSData *) readFile:(NSString *)fileName loadPath:(NSString *)path {
    NSString * document = [self getDocumentPath];
    NSString * pathTemp = [document stringByAppendingPathComponent:path];
    NSString * fileOper = [pathTemp stringByAppendingPathComponent:fileName];
    NSData * retData = nil;
    if ([self fileExists:fileName filePath:path]) {
        retData = [NSData dataWithContentsOfFile:fileOper];
    }
    return retData;
}

+(BOOL) fileExists:(NSString *)fileName filePath:(NSString *)path {
    NSString * document = [self getDocumentPath];
    NSString * pathTemp = [document stringByAppendingPathComponent:path];
    NSString * fileOper = [pathTemp stringByAppendingPathComponent:fileName];
    NSFileManager * fmgr = [NSFileManager defaultManager];
    return [fmgr fileExistsAtPath:fileOper];
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
