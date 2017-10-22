//
//  RSUURLProtocol.m
//  runsignup_mobile
//
//  Created by James Harris on 10/22/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import "RSUURLProtocol.h"
#import "constants.h"

@implementation RSUURLProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //static NSUInteger requestCount = 0;
    //NSLog(@"Request #%u: URL = %@", (unsigned int)requestCount++, request);
    
    if ([NSURLProtocol propertyForKey:RSU_URL_PROTOCOL_KEY inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    if( self.request != nil && self.request.URL != nil ) {
        NSMutableURLRequest *newRequest = [self.request mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:RSU_URL_PROTOCOL_KEY inRequest:newRequest];
        NSURL * actionURL = [newRequest URL];
        if( actionURL.host != nil ) {
            NSRange theRange = [actionURL.host rangeOfString:RSU_DOMAIN options:NSBackwardsSearch];
            if( theRange.location != NSNotFound ) {
                NSString * headerField = CUSTOM_HEADER_MOBILE_TYPE_FIELDNAME;
                NSString * headerValue = CUSTOM_HEADER_MOBILE_TYPE_FIELDVALUE;
                if (! [[newRequest valueForHTTPHeaderField:headerField] isEqualToString:headerValue]) {
                    [newRequest addValue:headerValue forHTTPHeaderField:headerField];
                }
            }
        }
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
    }
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
@end
