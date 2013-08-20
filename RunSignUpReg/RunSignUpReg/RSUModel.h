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

- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)retrieveRaceListWithParams:(NSDictionary *)params response:(void (^)(NSArray *))responseBlock;
- (void)retrieveRaceDetailsWithRaceID:(NSString *)raceID response:(void (^)(NSMutableDictionary *))responseBlock;
- (void)retrieveUserRaceList:(void (^)(NSArray *))responseBlock;
- (void)editUserWithInfo:(NSDictionary *)info response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)retrieveUserInfo:(void (^)(RSUConnectionResponse))responseBlock;
- (void)retrieveRaceRegistrationInformation:(void (^)(RSUConnectionResponse, NSDictionary *))responseBlock;
- (void)registerForRace:(NSString *)raceID withInfo:(NSDictionary *)info requestType:(RSURegistrationRequest)type response:(void (^)(RSUConnectionResponse, NSDictionary *))responseBlock;

- (void)logout;

- (NSMutableDictionary *)parseUser:(RXMLElement *)user;

@end
