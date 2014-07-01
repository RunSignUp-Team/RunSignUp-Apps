//
//  RSUModel.h
//  RunSignUpReg
//
// Copyright 2014 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
/* Params: 
 page: int
 name: string
 min_distance: float
 distance_units: K,M,Y,m
 start_date: date
 end_date: date
 country: country code
 state: state abbreviation
*/
- (void)retrieveRaceListWithParams:(NSDictionary *)params response:(void (^)(NSArray *))responseBlock;


// Retrieve specific race details for a given race with a raceID. Returns a mutable dictionary with race information, or nil if theres no connection.
- (void)retrieveRaceDetailsWithRaceID:(NSString *)raceID response:(void (^)(NSMutableDictionary *))responseBlock;


// Retrieve list of result sets in a given event
- (void)retrieveEventResultSetsWithRaceID:(NSString *)raceID eventID:(NSString *)eventID response:(void (^)(NSArray *))responseBlock;


// Retrieve results for a given event and result set id
- (void)retrieveEventResultsWithRaceID:(NSString *)raceID eventID:(NSString *)eventID resultSetID:(NSString *)resultSetID response:(void (^)(NSArray *))responseBlock;


// Retrieve a race director's race list. Unfinished, do not use.
- (void)retrieveUserRaceList:(void (^)(NSArray *))responseBlock;


// Edit a user's information. Returns a RSUConnectionResponse with success, invalid data or no connection.
/* Info:
 user_id: int
 first_name: string
 last_name: string
 dob: date
 gender: M,F
 phone: phone number
 address1: string
 city: string
 state: state abbreviation
 country: country code
 zipcode: string
 */
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
- (NSString *)standardizeDate:(NSString *)dateString;
- (NSString *)convertSlashDateToDashDate:(NSString *)slashDate;
- (NSString *)addressLine2FromAddress:(NSDictionary *)address;

@end
