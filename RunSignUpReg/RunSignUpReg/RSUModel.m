//
//  RSUModel.m
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

#import "RSUModel.h"
#import "RaceSignUpConfirmationViewController.h"

static RSUModel *model = nil;

@implementation RSUModel
@synthesize paymentViewController;
@synthesize apiKey;
@synthesize apiSecret;
@synthesize key;
@synthesize secret;
@synthesize email;
@synthesize password;
@synthesize signedIn;
@synthesize registrantType;
@synthesize currentUser;
@synthesize creditCardInfo;
@synthesize dataDict;

- (id)init{
    self = [super init];
    if(self){
        self.apiKey = API_KEY;
        self.apiSecret = API_SECRET;
        self.key = nil;
        self.secret = nil;
        self.email = nil;
        self.password = nil;
        self.signedIn = NO;
        self.registrantType = RSURegistrantMe;
        self.currentUser = nil;
        self.creditCardInfo = nil;
        self.dataDict = nil;
    }
    return self;
}

- (void)savePaymentInfoToServer:(NSDictionary *)paymentInfo{
    self.creditCardInfo = [[NSMutableDictionary alloc] initWithDictionary: paymentInfo];
    
    void (^response)(RSUConnectionResponse, NSDictionary *) = ^(RSUConnectionResponse didSucceed, NSDictionary *data){
        if(didSucceed == RSUSuccess){
            [dataDict setObject:data forKey:@"ConfirmationCodes"];
            
            [paymentViewController prepareForDismissal];
            RaceSignUpConfirmationViewController *rsucvc = [[RaceSignUpConfirmationViewController alloc] initWithNibName:@"RaceSignUpConfirmationViewController" bundle:nil data:dataDict];
            UINavigationController *navController = paymentViewController.navigationController;
            [navController popViewControllerAnimated: NO];
            [navController pushViewController:rsucvc animated:YES];
            [rsucvc release];
        }else if(didSucceed == RSUInvalidData && data != nil){
            if([data objectForKey:@"ErrorArray"] == nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error #%@: %@", [data objectForKey:@"error_code"], [data objectForKey:@"error_msg"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                NSString *errors = @"";
                
                for(NSString *error in [data objectForKey: @"ErrorArray"]){
                    errors = [errors stringByAppendingFormat:@"%@\n", error];
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errors delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [paymentViewController prepareForDismissal];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to register for race. Please try registration process again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [paymentViewController prepareForDismissal];
        }
    };
    
    [[RSUModel sharedModel] registerForRace:[dataDict objectForKey:@"race_id"] withInfo:dataDict requestType:RSURegRegister response:response];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [paymentViewController.navigationController popToRootViewControllerAnimated: YES];
}

- (void)paymentViewController:(BTPaymentViewController *)paymentViewController didSubmitCardWithInfo:(NSDictionary *)cardInfo andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted{
    NSLog(@"Info: %@", cardInfo);
    NSLog(@"Encrypted: %@", cardInfoEncrypted);
    [self savePaymentInfoToServer:cardInfo];
}

- (void)paymentViewController:(BTPaymentViewController *)paymentViewController didAuthorizeCardWithPaymentMethodCode:(NSString *)paymentMethodCode{
    /*NSLog(@"Payment method code: %@", paymentMethodCode);
    NSMutableDictionary *paymentInfo = [NSMutableDictionary dictionaryWithObject:paymentMethodCode forKey:@"venmo_sdk_payment_method_code"];
    [self savePaymentInfoToServer:paymentInfo];*/
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We're sorry, but Venmo Touch is not currently supported on RunSignUp Mobile." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)registerForRace:(NSString *)raceID withInfo:(NSDictionary *)info requestType:(RSURegistrationRequest)type response:(void (^)(RSUConnectionResponse, NSDictionary *))responseBlock{
    NSString *action = @"get-cart";
    
    switch(type){
        case RSURegGetCart:
            action = @"get-cart";
            break;
        case RSURegRegister:
            action = @"register";
            break;
        case RSURegRefund:
            action = @"refund";
            break;
    }
    
    NSLog(@"%@", info);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    if(type != RSURegRefund){
        NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] init]; // Request dictionary
        NSMutableArray *registrants = [[NSMutableArray alloc] init];
        NSMutableDictionary *registrant = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *userDict = nil;
        NSString *urlString = [NSString stringWithFormat: @"%@/rest/race/%@/registration", RUNSIGNUP_BASE_URL, raceID];
        if([[RSUModel sharedModel] signedIn]){
            if([[RSUModel sharedModel] registrantType] == RSURegistrantMe){
                userDict = [[[RSUModel sharedModel] currentUser] mutableCopy];
                urlString = [urlString stringByAppendingFormat:@"?tmp_key=%@&tmp_secret=%@", key, secret];
            }else{ //someoneelse or secondary
                userDict = [[info objectForKey:@"registrant"] mutableCopy];
                urlString = [urlString stringByAppendingFormat:@"?tmp_key=%@&tmp_secret=%@", key, secret];
            }
        }else if([[RSUModel sharedModel] registrantType] == RSURegistrantNewUser){
            userDict = [[info objectForKey:@"registrant"] mutableCopy];
        }
        
        if([info objectForKey:@"memberships"])
            [userDict setObject:[info objectForKey:@"memberships"] forKey:@"memberships"];
        
        if([info objectForKey:@"individual_question_responses"])
            [userDict setObject:[info objectForKey:@"individual_question_responses"] forKey:@"question_responses"];
        
        if(userDict == nil){
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
            return;
        }
        
        [registrant addEntriesFromDictionary: userDict];
        NSDictionary *addressDict = [userDict objectForKey: @"address"];
        [registrant setObject:[addressDict objectForKey:@"street"] forKey:@"address1"];
        [registrant setObject:[addressDict objectForKey:@"state"] forKey:@"state"];
        [registrant setObject:[addressDict objectForKey:@"city"] forKey:@"city"];
        [registrant setObject:[addressDict objectForKey:@"zipcode"] forKey:@"zipcode"];
        [registrant setObject:[addressDict objectForKey:@"country_code"] forKey:@"country_code"];
        [registrant removeObjectForKey: @"address"];
        
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for(NSDictionary *event in [info objectForKey:@"events"]){
            NSMutableDictionary *newEvent = [[NSMutableDictionary alloc] init];
            [newEvent setObject:[event objectForKey:@"event_id"] forKey:@"event_id"];
            if([event objectForKey:@"giveaway_option_id"] != nil){
                [newEvent setObject:[event objectForKey:@"giveaway_option_id"] forKey:@"giveaway_option_id"];
            }
            [events addObject: newEvent];
        }
        
        [registrant setObject:events forKey:@"events"];
        [registrants addObject: registrant];
        [reqDict setObject:@"T" forKey:@"waiver_accepted"];
        if(type == RSURegRegister){
            [reqDict setObject:[info objectForKey:@"total_cost"] forKey:@"total_cost"];
            if(![[info objectForKey:@"total_cost"] isEqualToString:@"$0.00"]){
                [reqDict setObject:[userDict objectForKey:@"first_name"] forKey:@"cc_first_name"];
                [reqDict setObject:[userDict objectForKey:@"last_name"] forKey:@"cc_last_name"];
                [reqDict setObject:[[userDict objectForKey:@"address"] objectForKey:@"street"] forKey:@"cc_address1"];
                [reqDict setObject:[[userDict objectForKey:@"address"] objectForKey:@"city"] forKey:@"cc_city"];
                [reqDict setObject:[[userDict objectForKey:@"address"] objectForKey:@"state"] forKey:@"cc_state"];
                [reqDict setObject:[[userDict objectForKey:@"address"] objectForKey:@"country_code"] forKey:@"cc_country_code"];
                [reqDict setObject:[creditCardInfo objectForKey:@"zipcode"] forKey:@"cc_zipcode"];
                [reqDict setObject:[creditCardInfo objectForKey:@"card_number"] forKey:@"cc_num"];
                [reqDict setObject:[creditCardInfo objectForKey:@"cvv"] forKey:@"cc_cvv"];
                [reqDict setObject:[NSString stringWithFormat:@"%@/%@", [creditCardInfo objectForKey:@"expiration_month"], [creditCardInfo objectForKey:@"expiration_year"]] forKey:@"cc_expires"];
            }
        }
        [reqDict setObject:registrants forKey:@"registrants"];
        if([info objectForKey:@"question_responses"])
            [reqDict setObject:[info objectForKey:@"question_responses"] forKey:@"question_responses"];
        NSLog(@"%@", reqDict);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        NSString *post = [NSString stringWithFormat:@"race_id=%@&request_format=json&action=%@&request=%@&tmp_key=", raceID, action, jsonString];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
    }else{
        NSString *requestString = [NSString stringWithFormat:@"{\"primary_registration_id\": \"%@\",\"primary_confirmation_code\": \"%@\"}", [[info objectForKey:@"ConfirmationCodes"] objectForKey:@"primary_registration_id"], [[info objectForKey:@"ConfirmationCodes"] objectForKey:@"primary_confirmation_code"]];
        
        NSString *post = [NSString stringWithFormat:@"race_id=%@&request_format=json&action=%@&request=%@&tmp_key=", raceID, action, requestString];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/rest/race/%@/registration", RUNSIGNUP_BASE_URL, raceID]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        
        if([[rootXML tag] isEqualToString:@"response"]){
            if(type == RSURegGetCart){
                NSMutableDictionary *cartDictionary = [[NSMutableDictionary alloc] init];
                RXMLElement *cart = [rootXML child: @"cart"];
                RXMLElement *baseCost = [rootXML child: @"base_cost"];
                RXMLElement *processingFee = [rootXML child: @"processing_fee"];
                RXMLElement *totalCost = [rootXML child: @"total_cost"];

                NSMutableArray *cartArray = [[NSMutableArray alloc] init];
                
                for(RXMLElement *cartItem in [cart children:@"cart_item"]){
                    NSMutableDictionary *cartItemDictionary = [[NSMutableDictionary alloc] init];
                    RXMLElement *info = [cartItem child: @"info"];
                    RXMLElement *perItemCost = [cartItem child: @"per_item_cost"];
                    RXMLElement *quantity = [cartItem child: @"quantity"];
                    RXMLElement *totalCost = [cartItem child: @"total_cost"];
                    RXMLElement *subitems = [cartItem child: @"subitems"];
                    NSMutableArray *subitemsArray = [[NSMutableArray alloc] init];
                    
                    for(RXMLElement *subitem in [subitems children: @"subitem"]){
                        [subitemsArray addObject: [subitem text]];
                    }
                    
                    if(info && perItemCost && quantity && totalCost){
                        [cartItemDictionary setObject:[info text] forKey:@"info"];
                        [cartItemDictionary setObject:[perItemCost text] forKey:@"per_item_cost"];
                        [cartItemDictionary setObject:[quantity text] forKey:@"quantity"];
                        [cartItemDictionary setObject:[totalCost text] forKey:@"total_cost"];

                    }
                    if([subitemsArray count] != 0)
                        [cartItemDictionary setObject:subitemsArray forKey:@"subitems"];
                    
                    [cartArray addObject: cartItemDictionary];
                    [cartItemDictionary release];
                }
                
                if(baseCost && processingFee && totalCost){
                    [cartDictionary setObject:[baseCost text] forKey:@"base_cost"];
                    [cartDictionary setObject:[processingFee text] forKey:@"processing_fee"];
                    [cartDictionary setObject:[totalCost text] forKey:@"total_cost"];
                    
                    if([cartArray count] > 0){
                        [cartDictionary setObject: cartArray forKey:@"cart"];
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, cartDictionary);});
                        return;
                    }
                }
            }else if(type == RSURegRegister){
                RXMLElement *primaryRegistrationID = [rootXML child: @"primary_registration_id"];
                RXMLElement *primaryConfirmationCode = [rootXML child: @"primary_confirmation_code"];
                
                if(primaryRegistrationID && primaryConfirmationCode){
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[primaryRegistrationID text] forKey:@"primary_registration_id"];
                    [dict setObject:[primaryConfirmationCode text] forKey:@"primary_confirmation_code"];
                    
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, dict);});
                    return;
                }
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, nil);});
                return;
            }else if(type == RSURegRefund){
                RXMLElement *success = [rootXML child: @"success"];
                if(success)
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, nil);});
                else
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, nil);});

                return;
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, nil);});
            return;
        }else if([[rootXML tag] isEqualToString:@"error"]){
            RXMLElement *errorCode = [rootXML child:@"error_code"];
            RXMLElement *errorMsg = [rootXML child:@"error_msg"];
            RXMLElement *errorDetails = [rootXML child:@"error_details"];
            
            if(errorCode && errorMsg && !errorDetails){
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:[errorCode text] forKey:@"error_code"];
                [dict setObject:[errorMsg text] forKey:@"error_msg"];
                
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, dict);});
                return;
            }else if(errorDetails){
                NSMutableArray *errorArray = [[NSMutableArray alloc] init];
                
                if([[errorDetails children:@"error"] count] > 0){
                    for(RXMLElement *error in [errorDetails children: @"error"]){
                        RXMLElement *message = [error child: @"error_msg"];
                        [errorArray addObject: [message text]];
                        
                    }
                }else{
                    RXMLElement *errorDetailsMsg = [errorDetails child: @"error_msg"];
                    if(errorDetailsMsg){
                        [errorArray addObject: [errorDetailsMsg text]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, [NSDictionary dictionaryWithObject:errorArray forKey:@"ErrorArray"]);});
                return;
            }

        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)retrieveRaceRegistrationInformation:(void (^)(RSUConnectionResponse, NSDictionary *))responseBlock{
    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, nil);});
    return;
}

/* Attempt to log in with the given email and password. Multiple responses
 can be returned: no connection, invalid email, invalid pass, success. If
 successful, then the secret and key are stored inside the RSUModel object. */
- (void)loginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock{
    self.email = em;
    self.password = pa;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", em, pa];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/rest/login", RUNSIGNUP_BASE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString:@"login"]){
            RXMLElement *tmp_key = [rootXML child:@"tmp_key"];
            RXMLElement *tmp_secret = [rootXML child:@"tmp_secret"];
            RXMLElement *user = [rootXML child:@"user"];
            self.currentUser = [self parseUser: user];
            
            if(tmp_key != nil && tmp_secret != nil){
                self.key = [tmp_key text];
                self.secret = [tmp_secret text];
                self.signedIn = YES;
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                return;
            }else{
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
        }else if([[rootXML tag] isEqualToString:@"error"]){
            RXMLElement *error_code = [rootXML child:@"error_code"];
            
            if([error_code textAsInt] == 101){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidEmail);});
                return;
            }else if([error_code textAsInt] == 102){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidPassword);});
                return;
            }
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)editUserWithInfo:(NSDictionary *)info response:(void (^)(RSUConnectionResponse))responseBlock{
    if([currentUser objectForKey:@"user_id"] != nil && info != nil){
        NSString *standardDob = [RSUModel standardizeDate: [info objectForKey: @"dob"]];
        NSString *dob = [RSUModel convertSlashDateToDashDate: standardDob];
        
        NSString *post = [NSString stringWithFormat:@"user_id=%@&first_name=%@&last_name=%@&dob=%@&gender=%@&phone=%@&address1=%@&city=%@&state=%@&country=%@&zipcode=%@",
                         [currentUser objectForKey:@"user_id"],[info objectForKey:@"first_name"],[info objectForKey:@"last_name"], dob,
                         [info objectForKey:@"gender"],[info objectForKey:@"phone"],[[info objectForKey:@"address"] objectForKey:@"street"],[[info objectForKey:@"address"] objectForKey:@"city"],
                         [[info objectForKey:@"address"] objectForKey:@"state"],[[info objectForKey:@"address"] objectForKey:@"country_code"],[[info objectForKey:@"address"] objectForKey:@"zipcode"]];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSString *url = [NSString stringWithFormat:@"%@/rest/user/%@/?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL,  [currentUser objectForKey:@"user_id"], key, secret];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            if(!urlData){
                NSLog(@"URLData is nil");
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString:@"user"]){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
            }else{
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData);});
            }
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (void)retrieveUserRaceList:(void (^)(NSArray *))responseBlock{
    if(!signedIn){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%@/rest/races?tmp_key=%@&tmp_secret=%@&events=T", RUNSIGNUP_BASE_URL, key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            NSMutableArray *raceList = [[NSMutableArray alloc] init];
            
            if(urlData != nil){
                RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
                if([[rootXML tag] isEqualToString:@"races"]){
                    NSArray *races = [rootXML children:@"race"];
                    if(races != nil){
                        for(RXMLElement *race in races){
                            RXMLElement *raceName = [race child:@"name"];
                            RXMLElement *raceID = [race child:@"race_id"];
                            RXMLElement *raceNextDate = [race child:@"next_date"];
                            RXMLElement *raceLastDate = [race child:@"last_date"];
                            RXMLElement *raceEvents = [race child:@"events"];
                            
                            NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
                            NSDictionary *raceDict = nil;
                            if(raceEvents != nil){
                                NSArray *events = [raceEvents children:@"event"];
                                for(RXMLElement *event in events){
                                    RXMLElement *eventName = [event child:@"name"];
                                    RXMLElement *eventID = [event child:@"event_id"];
                                    RXMLElement *eventStartTime = [event child:@"start_time"];
                                    
                                    if(eventName != nil && eventID != nil){
                                        NSString *curtailedName = [eventName text];
                                        if([curtailedName length] > 34)
                                            curtailedName = [curtailedName substringToIndex: 33];
                                        [eventsArray addObject: [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"name",[eventID text],@"event_id",[eventStartTime text],@"start_time", nil]];
                                    }
                                }
                            }
                            
                            if(raceName != nil && raceID != nil && [eventsArray count] != 0){
                                NSString *curtailedName = [raceName text];
                                if([curtailedName length] > 34)
                                    curtailedName = [curtailedName substringToIndex: 33];
                                raceDict = [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"name",[raceID text],@"race_id",[raceNextDate text],@"next_date",[raceLastDate text],@"last_date",eventsArray,@"events",nil];
                                [raceList addObject: raceDict];
                            }
                        }
                    }
                }
                
                if([raceList count] == 0)
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(raceList);});
            }else{
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            }
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (void)retrieveRaceListWithParams:(NSDictionary *)params response:(void (^)(NSArray *))responseBlock{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *urlString = [NSString stringWithFormat: @"%@/rest/races?events=T&sort=date+ASC,name+ASC", RUNSIGNUP_BASE_URL];
    if([params objectForKey:@"page"])
        urlString = [urlString stringByAppendingFormat:@"&page=%i", [[params objectForKey:@"page"] intValue]];
    if([params objectForKey:@"name"]){
        NSString *nameString = [[params objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        urlString = [urlString stringByAppendingFormat:@"&name=%@", nameString];
    }
    if([params objectForKey:@"min_distance"])
        urlString = [urlString stringByAppendingFormat:@"&min_distance=%@", [params objectForKey:@"min_distance"]];
    if([params objectForKey:@"distance_units"])
        urlString = [urlString stringByAppendingFormat:@"&distance_units=%@", [params objectForKey:@"distance_units"]];
    if([params objectForKey:@"start_date"])
        urlString = [urlString stringByAppendingFormat:@"&start_date=%@", [RSUModel convertSlashDateToDashDate: [params objectForKey:@"start_date"]]];
    if([params objectForKey:@"end_date"])
        urlString = [urlString stringByAppendingFormat:@"&end_date=%@", [RSUModel convertSlashDateToDashDate: [params objectForKey:@"end_date"]]];
    if([params objectForKey:@"country"])
        urlString = [urlString stringByAppendingFormat:@"&country=%@", [params objectForKey:@"country"]];
    if([params objectForKey:@"state"])
        urlString = [urlString stringByAppendingFormat:@"&state=%@", [params objectForKey:@"state"]];
    if([params objectForKey:@"city"]){
        NSString *cityString = [[params objectForKey:@"city"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        urlString = [urlString stringByAppendingFormat:@"&city=%@", cityString];
    }
    
    [request setURL:[NSURL URLWithString:urlString]];//[NSString stringWithFormat:@"%@&api_key=%@&api_secret=%@", urlString, apiKey, apiSecret]]];
    [request setHTTPMethod:@"GET"];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString:@"races"]){
            NSMutableArray *raceList = [[NSMutableArray alloc] init];
            NSArray *raceArray = [rootXML children:@"race"];
            for(int x = 0; x < [raceArray count]; x++){
                NSMutableDictionary *race = [[NSMutableDictionary alloc] init];
                RXMLElement *raceID = [[raceArray objectAtIndex: x] child: @"race_id"];
                RXMLElement *raceName = [[raceArray objectAtIndex: x] child: @"name"];
                RXMLElement *raceDescription = [[raceArray objectAtIndex: x] child: @"description"];
                RXMLElement *raceURL = [[raceArray objectAtIndex: x] child: @"url"];
                RXMLElement *raceNextDate = [[raceArray objectAtIndex: x] child: @"next_date"];
                RXMLElement *raceLastDate = [[raceArray objectAtIndex: x] child: @"last_date"];
                RXMLElement *raceAddress = [[raceArray objectAtIndex: x] child: @"address"];
                RXMLElement *raceRegistrationOpen = [[raceArray objectAtIndex: x] child:@"is_registration_open"];
                
                BOOL registrationOpen = NO;
                if(raceRegistrationOpen != nil && [[raceRegistrationOpen text] isEqualToString:@"T"])
                    registrationOpen = YES;
                
                [race setObject:[NSNumber numberWithBool: registrationOpen] forKey:@"is_registration_open"];
                
                for(RXMLElement *ele in @[raceID,raceName,raceDescription,raceURL,raceNextDate,raceLastDate,raceRegistrationOpen]){
                    if([ele text])
                        [race setObject:[ele text] forKey:[ele tag]];
                }
                
                if(raceID)
                    [race setObject:[raceID text] forKey:@"race_id"];
                if(raceName)
                    [race setObject:[raceName text] forKey:@"name"];
                if(raceDescription)
                    [race setObject:[raceDescription text] forKey:@"description"];
                if(raceURL)
                    [race setObject:[raceURL text] forKey:@"url"];
                if(raceNextDate && [[raceNextDate text] length])
                    [race setObject:[raceNextDate text] forKey:@"next_date"];
                else if(raceLastDate)
                    [race setObject:[raceLastDate text] forKey:@"next_date"];
                
                if(raceAddress){
                    RXMLElement *street = [raceAddress child: @"street"];
                    RXMLElement *city = [raceAddress child: @"city"];
                    RXMLElement *state = [raceAddress child: @"state"];
                    RXMLElement *zipcode = [raceAddress child: @"zipcode"];
                    RXMLElement *country = [raceAddress child: @"country_code"];
    
                    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
                    for(RXMLElement *ele in @[street,city,state,zipcode,country]){
                        if([ele text])
                            [address setObject:[ele text] forKey:[ele tag]];
                    }
                    
                    [race setObject:address forKey:@"address"];
                }
                
                NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
                RXMLElement *raceEvents = [[raceArray objectAtIndex: x] child: @"events"];
                if(raceEvents){
                    NSArray *events = [raceEvents children: @"event"];
                    for(int y = 0; y < [events count]; y++){
                        NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
                        RXMLElement *eventID = [[events objectAtIndex: y] child: @"event_id"];
                        RXMLElement *eventName = [[events objectAtIndex: y] child: @"name"];
                        RXMLElement *eventStartTime = [[events objectAtIndex: y] child: @"start_time"];
                        //RXMLElement *eventRegOpens = [[events objectAtIndex: y] child: @"registration_opens"];
                        RXMLElement *eventRegPeriods = [[events objectAtIndex: y] child: @"registration_periods"];
                        NSMutableArray *eventRegPeriodsArray = [[NSMutableArray alloc] init];
                        
                        for(RXMLElement *eventRegPeriod in [eventRegPeriods children:@"registration_period"]){
                            RXMLElement *eventRegPeriodOpens = [eventRegPeriod child: @"registration_opens"];
                            RXMLElement *eventRegPeriodCloses = [eventRegPeriod child: @"registration_closes"];
                            RXMLElement *eventRegPeriodFee = [eventRegPeriod child: @"race_fee"];
                            RXMLElement *eventRegPeriodProcessingFee = [eventRegPeriod child: @"processing_fee"];
                            
                            if(eventRegPeriodOpens && eventRegPeriodCloses && eventRegPeriodFee){
                                NSDictionary *eventRegPeriodDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                    [eventRegPeriodOpens text], @"registration_opens",
                                                                    [eventRegPeriodCloses text], @"registration_loses",
                                                                    [eventRegPeriodFee text], @"race_fee",
                                                                    [eventRegPeriodProcessingFee text], @"processing_fee",nil];
                                [eventRegPeriodsArray addObject: eventRegPeriodDict];
                            }
                        }
                        
                        if(eventID)
                            [event setObject:[eventID text] forKey:@"event_id"];
                        if(eventName)
                            [event setObject:[eventName text] forKey:@"name"];
                        if(eventStartTime)
                            [event setObject:[eventStartTime text] forKey:@"start_time"];
                        
                        [event setObject:eventRegPeriodsArray forKey:@"registration_periods"];
                        [eventsArray addObject: event];
                    }
                }
                [race setObject:eventsArray forKey:@"events"];
                [raceList addObject: race];
            }
            if([raceList count] > 0){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(raceList);});
                return;
            }

        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)retrieveRaceDetailsWithRaceID:(NSString *)raceID response:(void (^)(NSMutableDictionary *))responseBlock{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/rest/race?race_id=%@&future_events_only=F&include_waiver=T&include_giveaway_details=T&include_questions=T&include_membership_settings=T&race_headings=T&race_links=T&registration_api_supported_features=giveaway,questions,memberships", RUNSIGNUP_BASE_URL, raceID]]];
    [request setHTTPMethod:@"GET"];
    
    NSLog(@"Request URL: %@", [request URL]);
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString:@"race"]){
            NSMutableDictionary *race = [[NSMutableDictionary alloc] init];
            RXMLElement *raceID = [rootXML child: @"race_id"];
            RXMLElement *raceName = [rootXML child: @"name"];
            RXMLElement *raceDescription = [rootXML child: @"description"];
            RXMLElement *raceWaiver = [rootXML child: @"waiver"];
            RXMLElement *raceURL = [rootXML child: @"url"];
            RXMLElement *raceNextDate = [rootXML child: @"next_date"];
            RXMLElement *raceLastDate = [rootXML child: @"last_date"];
            RXMLElement *raceAddress = [rootXML child: @"address"];
            RXMLElement *raceRegistrationOpen = [rootXML child: @"is_registration_open"];
            RXMLElement *canUseRegistrationAPI = [rootXML child: @"can_use_registration_api"];
            RXMLElement *raceLatitude = [rootXML child: @"latitude"];
            RXMLElement *raceLongitude = [rootXML child: @"longitude"];
            
            BOOL registrationOpen = NO;
            if(raceRegistrationOpen != nil && [[raceRegistrationOpen text] isEqualToString:@"T"])
                registrationOpen = YES;
            
            [race setObject:[NSNumber numberWithBool: registrationOpen] forKey:[raceRegistrationOpen tag]];
            
            if(canUseRegistrationAPI != nil)
                [race setObject:[canUseRegistrationAPI text] forKey:[canUseRegistrationAPI tag]];
            
            for(RXMLElement *ele in @[raceID,raceName,raceDescription,raceNextDate,raceLastDate,raceRegistrationOpen]){
                if([ele text]){
                    [race setObject:[ele text] forKey:[ele tag]];
                }
            }
            
            if(raceLatitude)
                [race setObject:[raceLatitude text] forKey:[raceLatitude tag]];
            
            if(raceLongitude)
                [race setObject:[raceLongitude text] forKey:[raceLongitude tag]];
            
            if(raceWaiver)
                [race setObject:[raceWaiver text] forKey:[raceWaiver tag]];
            if(raceURL)
                [race setObject:[raceURL text] forKey:[raceURL tag]];
            
            if(raceAddress){
                RXMLElement *street = [raceAddress child: @"street"];
                RXMLElement *city = [raceAddress child: @"city"];
                RXMLElement *state = [raceAddress child: @"state"];
                RXMLElement *zipcode = [raceAddress child: @"zipcode"];
                RXMLElement *country = [raceAddress child: @"country_code"];
                
                NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
                for(RXMLElement *ele in @[street,city,state,zipcode,country]){
                    if([ele text])
                        [address setObject:[ele text] forKey:[ele tag]];
                }
                
                [race setObject:address forKey:@"address"];
            }
            
            NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
            RXMLElement *raceEvents = [rootXML child: @"events"];
            if(raceEvents){
                NSArray *events = [raceEvents children: @"event"];
                for(int y = 0; y < [events count]; y++){
                    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
                    RXMLElement *eventID = [[events objectAtIndex: y] child: @"event_id"];
                    RXMLElement *eventName = [[events objectAtIndex: y] child: @"name"];
                    RXMLElement *eventStartTime = [[events objectAtIndex: y] child: @"start_time"];
                    //RXMLElement *eventRegOpens = [[events objectAtIndex: y] child: @"registration_opens"];
                    RXMLElement *eventRegPeriods = [[events objectAtIndex: y] child: @"registration_periods"];
                    RXMLElement *eventGiveaway = [[events objectAtIndex: y] child: @"giveaway"];
                    RXMLElement *eventGiveawayOptions = [[events objectAtIndex: y] child: @"giveaway_options"];
                    
                    NSMutableArray *eventRegPeriodsArray = [[NSMutableArray alloc] init];
                    NSMutableArray *eventGiveawayOptionsArray = [[NSMutableArray alloc] init];
                    
                    for(RXMLElement *eventRegPeriod in [eventRegPeriods children:@"registration_period"]){
                        RXMLElement *eventRegPeriodOpens = [eventRegPeriod child: @"registration_opens"];
                        RXMLElement *eventRegPeriodCloses = [eventRegPeriod child: @"registration_closes"];
                        RXMLElement *eventRegPeriodFee = [eventRegPeriod child: @"race_fee"];
                        RXMLElement *eventRegPeriodProcessingFee = [eventRegPeriod child: @"processing_fee"];
                        
                        if(eventRegPeriodOpens && eventRegPeriodCloses && eventRegPeriodFee){
                            NSDictionary *eventRegPeriodDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                [eventRegPeriodOpens text], [eventRegPeriodOpens tag],
                                                                [eventRegPeriodCloses text], [eventRegPeriodCloses tag],
                                                                [eventRegPeriodFee text], [eventRegPeriodFee tag],
                                                                [eventRegPeriodProcessingFee text], [eventRegPeriodProcessingFee tag],nil];
                            [eventRegPeriodsArray addObject: eventRegPeriodDict];
                        }
                    }
                    
                    for(RXMLElement *eventGiveawayOption in [eventGiveawayOptions children:@"giveaway_option"]){
                        RXMLElement *eventGiveawayOptionID = [eventGiveawayOption child: @"giveaway_option_id"];
                        RXMLElement *eventGiveawayOptionText = [eventGiveawayOption child: @"giveaway_option_text"];
                        RXMLElement *eventGiveawayAdditionalCost = [eventGiveawayOption child: @"additional_cost"];
                        
                        if(eventGiveawayOptionID && eventGiveawayOptionText && eventGiveawayAdditionalCost){
                            NSDictionary *eventGiveawayOptionDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     [eventGiveawayOptionID text], [eventGiveawayOptionID tag],
                                                                     [eventGiveawayOptionText text], [eventGiveawayOptionText tag],
                                                                     [eventGiveawayAdditionalCost text], [eventGiveawayAdditionalCost tag], nil];
                            [eventGiveawayOptionsArray addObject: eventGiveawayOptionDict];
                        }
                    }
                    
                    if(eventID)
                        [event setObject:[eventID text] forKey:[eventID tag]];
                    if(eventName)
                        [event setObject:[eventName text] forKey:[eventName tag]];
                    if(eventStartTime)
                        [event setObject:[eventStartTime text] forKey:[eventStartTime tag]];
                    if(eventGiveaway)
                        [event setObject:[eventGiveaway text] forKey:[eventGiveaway tag]];
                    
                    [event setObject:eventRegPeriodsArray forKey:@"registration_periods"];
                    if([eventGiveawayOptionsArray count] != 0)
                        [event setObject:eventGiveawayOptionsArray forKey:@"giveaway_options"];
                    [eventsArray addObject: event];
                }
            }

            [race setObject:eventsArray forKey:@"events"];
            
            NSMutableArray *questionsArray = [[NSMutableArray alloc] init];
            
            RXMLElement *questions = [rootXML child: @"questions"];
            for(RXMLElement *question in [questions children: @"question"]){
                RXMLElement *questionID = [question child: @"question_id"];
                RXMLElement *questionText = [question child: @"question_text"];
                RXMLElement *questionType = [question child: @"question_type"];
                RXMLElement *questionTypeCode = [question child: @"question_type_code"];
                RXMLElement *questionValidationType = [question child: @"question_validation_type"];
                RXMLElement *questionIndividual = [question child: @"individual"];
                RXMLElement *questionRequired = [question child: @"required"];
                RXMLElement *questionSkipForEventIDs = [question child: @"skip_for_event_ids"];
                RXMLElement *questionResponses = [question child: @"responses"];
                RXMLElement *parentQuestionID = [question child: @"parent_question_id"];
                
                NSMutableDictionary *questionDict = [[NSMutableDictionary alloc] init];
                
                for(RXMLElement *ele in @[questionID, questionText, questionType, questionTypeCode, questionIndividual, questionRequired]){
                    if([ele text])
                        [questionDict setObject:[ele text] forKey:[ele tag]];
                }
                
                if(questionValidationType)
                    [questionDict setObject:[questionValidationType text] forKey:[questionValidationType tag]];
                
                if(questionSkipForEventIDs && [questionSkipForEventIDs children: @"event_id"] != nil){
                    NSMutableArray *skipEvents = [[NSMutableArray alloc] init];
                    for(RXMLElement *eventID in [questionSkipForEventIDs children: @"event_id"]){
                        [skipEvents addObject: [eventID text]];
                    }
                    if([skipEvents count] > 0)
                        [questionDict setObject:skipEvents forKey:@"skip_for_event_ids"];
                }
                
                if(parentQuestionID){
                    [questionDict setObject:[parentQuestionID text] forKey:[parentQuestionID tag]];
                    
                    RXMLElement *parentVisibleBoolResponse = [question child: @"parent_visible_bool_response"];
                    RXMLElement *parentVisibleResponseIDs = [question child: @"parent_visible_response_ids"];
                    
                    if(parentVisibleBoolResponse){
                        [questionDict setObject:[parentVisibleBoolResponse text] forKey:[parentVisibleBoolResponse tag]];
                    }else if(parentVisibleResponseIDs){
                        NSMutableArray *responseIDs = [[NSMutableArray alloc] init];
                        for(RXMLElement *response in [parentVisibleResponseIDs children: @"response_id"]){
                            [responseIDs addObject: [response text]];
                        }
                        [questionDict setObject:responseIDs forKey:[parentVisibleResponseIDs tag]];
                    }
                }
                    
                if(questionResponses){
                    NSMutableArray *responsesArray = [[NSMutableArray alloc] init];
                    for(RXMLElement *response in [questionResponses children: @"response"]){
                        RXMLElement *responseID = [response child: @"response_id"];
                        RXMLElement *responseText = [response child: @"response"];
                        
                        NSDictionary *responseDict = [[NSDictionary alloc] initWithObjectsAndKeys:[responseID text], @"response_id", [responseText text], @"response", nil];
                        [responsesArray addObject: responseDict];
                    }
                    
                    [questionDict setObject:responsesArray forKey:@"responses"];
                }
                
                [questionsArray addObject: questionDict];
            }
            
            if(questionsArray && [questionsArray count] > 0)
                [race setObject:questionsArray forKey:@"questions"];
            
            NSMutableArray *membershipsArray = [[NSMutableArray alloc] init];
            RXMLElement *memberships = [rootXML child: @"membership_settings"];
            for(RXMLElement *membership in [memberships children: @"membership_setting"]){
                RXMLElement *membershipSettingID = [membership child: @"membership_setting_id"];
                RXMLElement *membershipSettingName = [membership child: @"membership_setting_name"];
                RXMLElement *priceAdjustment = [membership child: @"price_adjustment"];
                RXMLElement *applyPriceAdjustmentForNonMember = [membership child: @"apply_price_adjustment_for_non_member"];
                RXMLElement *membershipSettingAddlField = [membership child: @"membership_setting_addl_field"];
                RXMLElement *expiresXDaysBeforeEvent = [membership child: @"expires_x_days_before_event"];
                RXMLElement *userNotice = [membership child: @"user_notice"];
                
                RXMLElement *usatfSpecific = [membership child: @"usatf_specific"];
                
                NSMutableDictionary *membershipDict = [[NSMutableDictionary alloc] init];
                
                for(RXMLElement *ele in @[membershipSettingID, membershipSettingName, priceAdjustment, applyPriceAdjustmentForNonMember, expiresXDaysBeforeEvent]){
                    if([ele text])
                        [membershipDict setObject:[ele text] forKey:[ele tag]];
                }
                
                if(userNotice)
                    [membershipDict setObject:[userNotice text] forKey:[userNotice tag]];
                if(usatfSpecific)
                    [membershipDict setObject:[usatfSpecific text] forKey:[usatfSpecific tag]];
                
                if(membershipSettingAddlField){
                    RXMLElement *fieldText = [membershipSettingAddlField child: @"field_text"];
                    RXMLElement *required = [membershipSettingAddlField child: @"required"];
                    
                    NSDictionary *additionalField = [[NSDictionary alloc] initWithObjectsAndKeys:[fieldText text], [fieldText tag], [required text], [required tag], nil];
                    [membershipDict setObject:additionalField forKey:@"membership_setting_addl_field"];
                }
                
                [membershipsArray addObject: membershipDict];
            }
            
            if(membershipsArray && [membershipsArray count] > 0)
                [race setObject:membershipsArray forKey:@"membership_settings"];
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(race);});
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)retrieveEventResultSetsWithRaceID:(NSString *)raceID eventID:(NSString *)eventID response:(void (^)(NSArray *))responseBlock{
    NSString *url = [NSString stringWithFormat:@"%@/rest/race/%@/results?event_id=%@&request_type=get-result-sets&format=xml", RUNSIGNUP_BASE_URL, raceID, eventID];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        NSMutableArray *resultSetList = [[NSMutableArray alloc] init];
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        
        if(urlData != nil){
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString:@"event_individual_results"]){
                NSArray *individualResultSets = [rootXML children:@"individual_results_set"];
                if(individualResultSets != nil){
                    for(int x = 0; x < [individualResultSets count]; x++){
                        RXMLElement *individualResult = [[rootXML children:@"individual_results_set"] objectAtIndex: x];
                        RXMLElement *individualResultName = [individualResult child: @"individual_result_set_name"];
                        RXMLElement *individualResultID = [individualResult child: @"individual_result_set_id"];
                        //RXMLElement *resultsHeaders = [individualResult child: @"results_headers"];
                        
                        if(individualResultID != nil && individualResultName != nil){
                            /*NSMutableArray *headersArray = [[NSMutableArray alloc] init];
                             
                             if(resultsHeaders != nil){
                             for(RXMLElement *field in [resultsHeaders children: @"field"]){
                             RXMLElement *name = [field child: @"name"];
                             
                             if(name != nil && [name text] != nil)
                             [headersArray addObject: [name text]];
                             }
                             }
                             */
                            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[individualResultName text], @"individual_result_set_name", [individualResultID text], @"individual_result_set_id", nil];
                            [resultSetList addObject: dict];
                        }
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(resultSetList);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];

}

- (void)retrieveEventResultsWithRaceID:(NSString *)raceID eventID:(NSString *)eventID resultSetID:(NSString *)resultSetID response:(void (^)(NSArray *))responseBlock{
    NSString *url = [NSString stringWithFormat:@"%@/rest/race/%@/results?event_id=%@&request_type=get-results&individual_result_set_id=%@&tmp_key=%@&tmp_secret=%@&format=xml", RUNSIGNUP_BASE_URL, raceID, eventID, resultSetID, key, secret];
    NSLog(@"%@", url);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        
        if(urlData != nil){
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString:@"event_individual_results"]){
                NSArray *individualResultSets = [rootXML children:@"individual_results_set"];
                if(individualResultSets != nil){
                    RXMLElement *results = [[individualResultSets firstObject] child: @"results"];
                    if(results != nil){
                        NSArray *resultArray = [results children: @"result"];
                        
                        for(RXMLElement *result in resultArray){
                            NSArray *fields = [result children: @"field"];
                            NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
                            
                            for(RXMLElement *field in fields){
                                RXMLElement *name = [field child: @"name"];
                                RXMLElement *value = [field child: @"value"];
                                
                                if(name != nil && value != nil && [[value text] length] > 0){
                                    [resultDict setObject:[value text] forKey:[name text]];
                                }
                            }
                            
                            [resultsArray addObject: resultDict];
                        }
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(resultsArray);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];

}

- (void)retrieveUserInfo:(void (^)(RSUConnectionResponse))responseBlock{
    if(!signedIn){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%@/rest/user/%@/?tmp_key=%@&tmp_secret=%@&include_secondary_users=T", RUNSIGNUP_BASE_URL, [currentUser objectForKey:@"user_id"], key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){                        
            if(urlData != nil){
                NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", string);

                RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
                if([[rootXML tag] isEqualToString:@"user"]){
                    self.currentUser = [self parseUser: rootXML];
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                    return;
                }else{
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                    return;
                }
            }
            
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});

        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];

    }
}

/* Renew credentials every X amount of time so the user does not get logged out due to
 inactivity. */
- (int)renewCredentials{
    NSString *url = [NSString stringWithFormat:@"%@/rest/user?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL, key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(urlData){
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if(![[rootXML tag] isEqualToString:@"user"]){
            //int attempt = [self loginWithEmail:email pass:password];
            return RSUNoConnection;
        }
    }else{
        return RSUNoConnection;
    }
    
    return RSUSuccess;

}

/* Log out the current user in a synchronous manner to tie up any loose ends. Not completely
 necessary but good practice all the same */
- (void)logout{
    NSString *url = [NSString stringWithFormat:@"%@/rest/logout?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL, key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    urlData = nil;
    self.key = nil;
    self.secret = nil;
    self.email = nil;
    self.password = nil;
    self.signedIn = NO;
}

- (NSMutableDictionary *)parseUser:(RXMLElement *)user{
    if([[user tag] isEqualToString:@"user"]){
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        RXMLElement *userID = [user child:@"user_id"];
        RXMLElement *fname = [user child:@"first_name"];
        RXMLElement *lname = [user child:@"last_name"];
        RXMLElement *emailAddress = [user child:@"email"];
        RXMLElement *gender = [user child:@"gender"];
        RXMLElement *phone = [user child:@"phone"];
        RXMLElement *profileImage = [user child:@"profile_image_url"];
        RXMLElement *dob = [user child:@"dob"];
        RXMLElement *address = [user child:@"address"];
        
        for(RXMLElement *ele in @[userID,fname,lname]){
            if([ele text]){
                [userDict setObject:[ele text] forKey:[ele tag]];
            }
        }
        
        if(emailAddress){
            [userDict setObject:[emailAddress text] forKey:[emailAddress tag]];
        }
        
        if(gender){
            [userDict setObject:[gender text] forKey:[gender tag]];
        }
        
        if(phone){
            [userDict setObject:[phone text] forKey:[phone tag]];
        }
        
        if(profileImage){
            [userDict setObject:[profileImage text] forKey:[profileImage tag]];
        }
        
        if(dob){
            NSString *realDob = [RSUModel standardizeDate: [dob text]];
            [userDict setObject:realDob forKey:@"dob"];
        }
        
        if(address){
            NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
            RXMLElement *street = [address child:@"street"];
            RXMLElement *city = [address child:@"city"];
            RXMLElement *state = [address child:@"state"];
            RXMLElement *zipcode = [address child:@"zipcode"];
            RXMLElement *country = [address child:@"country_code"];
            
            for(RXMLElement *ele in @[street,city,state,zipcode,country]){
                if([ele text]){
                    [addressDict setObject:[ele text] forKey:[ele tag]];
                }
            }
            
            [userDict setObject:addressDict forKey:@"address"];
            [addressDict release];
        }
        
        RXMLElement *secondaryUsers = [user child: @"secondary_users"];
        if(secondaryUsers){
            NSMutableArray *secondaryUsersArray = [[NSMutableArray alloc] init];

            for(RXMLElement *secondaryUser in [secondaryUsers children: @"user"]){
                NSMutableDictionary *secondaryUserDict = [self parseUser: secondaryUser];
                [secondaryUsersArray addObject: secondaryUserDict];
                [secondaryUserDict release];
            }
            [userDict setObject:secondaryUsersArray forKey:@"secondary_users"];
        }
        
        return userDict;
    }else{
        return nil;
    }
}

+ (NSString *)standardizeDate:(NSString *)dateString{
    NSArray *dateParts = [dateString componentsSeparatedByString:@"/"];
    if([dateParts count] == 3){
        NSString *realDob = [NSString stringWithFormat:@"%02d/%02d/%04d", [[dateParts objectAtIndex: 0] intValue], [[dateParts objectAtIndex: 1] intValue], [[dateParts objectAtIndex: 2] intValue]];
        return realDob;
    }
    return dateString;
}

+ (NSString *)convertSlashDateToDashDate:(NSString *)slashDate{
    if([slashDate length] == 10){
        return [NSString stringWithFormat:@"%@-%@-%@", [slashDate substringWithRange:NSRangeFromString(@"6-4")], [slashDate substringWithRange:NSRangeFromString(@"0-2")], [slashDate substringWithRange:NSRangeFromString(@"3-2")]];
    }
    return @"Error";
}

+ (NSString *)addressLine2FromAddress:(NSDictionary *)address{
    return [NSString stringWithFormat:@"%@ %@ %@, %@", [address objectForKey:@"city"], [address objectForKey:@"state"], [address objectForKey:@"country_code"], [address objectForKey:@"zipcode"]];
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end