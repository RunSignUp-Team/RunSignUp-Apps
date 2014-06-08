//
//  AddressAnnotation.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 5/21/14.
//
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c{
    self = [super init];
    if(self){
        coordinate = c;
    }
    return self;
}

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return nil;
}

@end
