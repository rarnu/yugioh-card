#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+(void) writeTextFile: (NSString *) fileName savePath: (NSString *) path fileContent: (NSString *) text;

+(NSString *) readTextFile : (NSString *) fileName loadPath: (NSString *) path;

+(void) writeFile: (NSString *) fileName savePath: (NSString *) path fileData: (NSData *) data;

+(NSData *) readFile: (NSString *) fileName loadPath: (NSString *) path;

+(BOOL) fileExists: (NSString *) fileName filePath: (NSString *) path;

@end
