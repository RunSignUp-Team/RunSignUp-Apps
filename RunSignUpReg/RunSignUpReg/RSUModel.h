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

@interface RSUModel : NSObject <BTPaymentViewControllerDelegate>{
    BTPaymentViewController *paymentViewController;
    
    NSMutableDictionary *dataDict;
    
    NSString *apiKey;
    NSString *apiSecret;
    
    NSString *key;
    NSString *secret;
    
    NSString *email;
    NSString *password;
    
    BOOL signedIn;
        
    NSDictionary *lastParsedUser;
}

@property (nonatomic, retain) BTPaymentViewController *paymentViewController;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *apiSecret;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property BOOL signedIn;
@property (nonatomic, retain) NSDictionary *lastParsedUser;
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

- (void)logout;

- (void)parseUser:(RXMLElement *)user;

@end
