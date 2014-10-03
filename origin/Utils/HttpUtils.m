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
    self.receivedData = [[NSMutableData alloc] init];
    if ([self.delegate respondsToSelector:@selector(httpUtils:receivedFileSize:)]) {
        [self.delegate httpUtils:self receivedFileSize:response.expectedContentLength];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
    if ([self.delegate respondsToSelector:@selector(httpUtils:receivedProgress:)]) {
        [self.delegate httpUtils:self receivedProgress:self.receivedData.length];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(httpUtils:receivedData:)]) {
        [self.delegate httpUtils:self receivedData:self.receivedData];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(httpUtils:receivedError:)]) {
        [self.delegate httpUtils:self receivedError:[error localizedDescription]];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
