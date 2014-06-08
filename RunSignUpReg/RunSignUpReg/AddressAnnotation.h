//
//  AddressAnnotation.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 5/21/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c;

@end
