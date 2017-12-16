//
//  RSUURLProtocol.h
//  runsignup_mobile
//
//  Created by James Harris on 10/22/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSUURLProtocol : NSURLProtocol <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;


@end
