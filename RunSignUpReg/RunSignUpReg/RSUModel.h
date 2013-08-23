//
//  RSUModel.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"
#import "BTPaymentViewController.h"

typedef enum{
    RSUNoConnection = 0,
    RSUInvalidEmail,
    RSUInvalidPassword,
    RSUSuccess,
    RSUInvalidData
} RSUConnectionResponse;
     
typedef enum{
    RSURegGetCart = 10,
    RSURegRegister,
    RSURegRefund
}RSURegistrationRequest;

typedef enum{
    RSURegistrantMe = 20,
    RSURegistrantNewUser,
    RSURegistrantSomeoneElse,
    RSURegistrantSecondary
}RSURegistrantType;

@interface RSUModel : NSObject <BTPaymentViewControllerDelegate, UIAlertViewDelegate>{
    BTPaymentViewController *paymentViewController;
    
    NSMutableDictionary *dataDict;
    
    NSString *apiKey;
    NSString *apiSecret;
    
    NSString *key;
    NSString *secret;
    
    NSString *email;
    NSString *password;
    
    BOOL signedIn;
    
    RSURegistrantType registrantType;
    NSDictionary *currentUser;
    NSMutableDictionary *creditCardInfo;
}

@property (nonatomic, retain) BTPaymentViewController *paymentViewController;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *apiSecret;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property BOOL signedIn;
@property RSURegistrantType registrantType;
@property (nonatomic, retain) NSDictionary *currentUser;
@property (nonatomic, retain) NSMutableDictionary *creditCardInfo;
@property (nonatomic, retain) NSMutableDictionary *dataDict;

+ (id)sharedModel;

- (void)savePaymentInfoToServer:(NSDictionary *)paymentInfo;

- (id)init;
- (int)renewCredentials;

// Login to the REST API. Returns a RSUConnectionResponse with success, invalid email/pass or no connection.
- (void)loginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock;

// Retrieve a list of races from the REST API. Returns an array with race information, or a nil array if theres no connection.
- (void)retrieveRaceListWithParams:(NSDictionary *)params response:(void (^)(NSArray *))responseBlock;

// Retrieve specific race details for a given race with a raceID. Returns a mutable dictionary with race information, or nil if theres no connection.
- (void)retrieveRaceDetailsWithRaceID:(NSString *)raceID response:(void (^)(NSMutableDictionary *))responseBlock;

// Retrieve a race director's race list. Unfinished, do not use.
- (void)retrieveUserRaceList:(void (^)(NSArray *))responseBlock;

// Edit a user's information. Returns a RSUConnectionResponse with success, invalid data or no connection.
- (void)editUserWithInfo:(NSDictionary *)info response:(void (^)(RSUConnectionResponse))responseBlock;

// Retrieve the currently logged in user's information. Places data in currentUser. Returns a RSUConnectionResponse.
- (void)retrieveUserInfo:(void (^)(RSUConnectionResponse))responseBlock;

// Register for race with raceID and sign up information. Request type may be get-cart, register or refund.
// get-cart requires full information but no credit card information.
// register requires full information and credit card information.
// refund requires no log in or information except the codes stored in info's key @"ConfirmationCodes"
- (void)registerForRace:(NSString *)raceID withInfo:(NSDictionary *)info requestType:(RSURegistrationRequest)type response:(void (^)(RSUConnectionResponse, NSDictionary *))responseBlock;

// Logout of the REST API.
- (void)logout;

- (NSMutableDictionary *)parseUser:(RXMLElement *)user;

@end
