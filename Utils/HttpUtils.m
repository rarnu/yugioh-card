#import "HttpUtils.h"

@implementation HttpUtils

-(void) get:(NSString *)url {
    NSURL * u = [NSURL URLWithString:url];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:u cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
}

-(void) post:(NSString *)url param:(NSString *)param {
    NSURL * u = [NSURL URLWithString:url];;
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:u];
    req.HTTPMethod = @"POST";
    req.timeoutInterval = 60;
    NSData * data = [param dataUsingEncoding:NSUTF8StringEncoding];
    req.HTTPBody = data;
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [NSMutableData data];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(receivedData:)]) {
        [self.delegate receivedData:self.receivedData];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(receivedError:)]) {
        [self.delegate receivedError:[error localizedDescription]];
    }
}

@end
