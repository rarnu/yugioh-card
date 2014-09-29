#import <Foundation/Foundation.h>

@class HttpUtils;

@protocol HttpUtilsDelegate <NSObject>

@optional
-(void) httpUtils:(HttpUtils *) httpUtils receivedData: (NSData *) data;
-(void) httpUtils:(HttpUtils *) httpUtils receivedError: (NSString *) err;
-(void) httpUtils:(HttpUtils *) httpUtils receivedFileSize: (long long) fileSize;
-(void) httpUtils:(HttpUtils *) httpUtils receivedProgress: (long long) progress;
@end

@interface HttpUtils : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic) NSMutableData * receivedData;
@property id<HttpUtilsDelegate> delegate;
@property (nonatomic) int tag;

-(void) get: (NSString *) url;
-(void) post: (NSString *) url param: (NSString *) param;

@end
