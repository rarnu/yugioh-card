#import <Foundation/Foundation.h>

@protocol HttpUtilsDelegate <NSObject>

@optional
-(void) receivedData: (NSData *) data;
-(void) receivedError: (NSString *) err;

@end

@interface HttpUtils : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic) NSMutableData * receivedData;
@property id<HttpUtilsDelegate> delegate;

-(void) get: (NSString *) url;
-(void) post: (NSString *) url param: (NSString *) param;

@end
