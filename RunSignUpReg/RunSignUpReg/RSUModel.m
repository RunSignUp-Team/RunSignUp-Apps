//
//  RSUModel.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
    if(self.creditCardInfo == nil){
        self.creditCardInfo = [[NSMutableDictionary alloc] init];
    }

    [creditCardInfo setObject:[paymentInfo objectForKey:@"card_number"] forKey:@"CCNumber"];
    [creditCardInfo setObject:[paymentInfo objectForKey:@"cvv"] forKey:@"CCCVV"];
    [creditCardInfo setObject:[NSString stringWithFormat:@"%@/%@", [paymentInfo objectForKey:@"expiration_month"], [paymentInfo objectForKey:@"expiration_year"]] forKey:@"CCExpires"];
    [creditCardInfo setObject:[paymentInfo objectForKey:@"zipcode"] forKey:@"CCZipcode"];

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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error #%@: %@", [data objectForKey:@"ErrorCode"], [data objectForKey:@"ErrorMessage"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                NSString *errors = @"Errors: ";
                for(NSString *error in [data objectForKey: @"ErrorArray"]){
                    errors = [errors stringByAppendingFormat:@"%@, ", error];
                }
                errors = [errors substringToIndex: [errors length] - 2];
                
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
    
    [[RSUModel sharedModel] registerForRace:[dataDict objectForKey:@"RaceID"] withInfo:dataDict requestType:RSURegRegister response:response];
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
        
        NSDictionary *userDict = nil;
        NSString *urlString = [NSString stringWithFormat: @"%@/rest/race/%@/registration", RUNSIGNUP_BASE_URL, raceID];
        if([[RSUModel sharedModel] signedIn]){
            if([[RSUModel sharedModel] registrantType] == RSURegistrantMe){
                userDict = [[RSUModel sharedModel] currentUser];
                urlString = [urlString stringByAppendingFormat:@"?tmp_key=%@&tmp_secret=%@", key, secret];
            }else{ //someoneelse or secondary
                userDict = [info objectForKey:@"Registrant"];
                urlString = [urlString stringByAppendingFormat:@"?tmp_key=%@&tmp_secret=%@", key, secret];
            }
        }else if([[RSUModel sharedModel] registrantType] == RSURegistrantNewUser){
            userDict = [info objectForKey:@"Registrant"];
        }
        
        if(userDict == nil){
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
            return;
        }
        
        if([userDict objectForKey:@"UserID"])
            [registrant setObject:[userDict objectForKey:@"UserID"] forKey:@"user_id"];
        if([userDict objectForKey:@"FName"])
            [registrant setObject:[userDict objectForKey:@"FName"] forKey:@"first_name"];
        if([userDict objectForKey:@"LName"])
            [registrant setObject:[userDict objectForKey:@"LName"] forKey:@"last_name"];
        if([userDict objectForKey:@"Email"])
            [registrant setObject:[userDict objectForKey:@"Email"] forKey:@"email"];
        if([userDict objectForKey:@"Street"])
            [registrant setObject:[userDict objectForKey:@"Street"] forKey:@"address1"];
        if([userDict objectForKey:@"City"])
            [registrant setObject:[userDict objectForKey:@"City"] forKey:@"city"];
        if([userDict objectForKey:@"State"])
            [registrant setObject:[userDict objectForKey:@"State"] forKey:@"state"];
        if([userDict objectForKey:@"Country"])
            [registrant setObject:[userDict objectForKey:@"Country"] forKey:@"country_code"];
        if([userDict objectForKey:@"Zipcode"])
            [registrant setObject:[userDict objectForKey:@"Zipcode"] forKey:@"zipcode"];
        if([userDict objectForKey:@"Phone"])
            [registrant setObject:[userDict objectForKey:@"Phone"] forKey:@"phone"];
        if([userDict objectForKey:@"DOB"])
            [registrant setObject:[userDict objectForKey:@"DOB"] forKey:@"dob"];
        if([userDict objectForKey:@"Gender"])
            [registrant setObject:[userDict objectForKey:@"Gender"] forKey:@"gender"];
        if([userDict objectForKey:@"Password"])
            [registrant setObject:[userDict objectForKey:@"Gender"] forKey:@"password"];
        
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for(NSDictionary *event in [info objectForKey:@"Events"]){
            NSMutableDictionary *newEvent = [[NSMutableDictionary alloc] init];
            [newEvent setObject:[event objectForKey:@"EventID"] forKey:@"event_id"];
            if([event objectForKey:@"GiveawayOptionID"] != nil){
                [newEvent setObject:[event objectForKey:@"GiveawayOptionID"] forKey:@"giveaway_option_id"];
            }
            [events addObject: newEvent];
        }
        
        [registrant setObject:events forKey:@"events"];
        [registrants addObject: registrant];
        [reqDict setObject:@"T" forKey:@"waiver_accepted"];
        if(type == RSURegRegister){
            [reqDict setObject:[info objectForKey:@"TotalCost"] forKey:@"total_cost"];
            if(![[info objectForKey:@"TotalCost"] isEqualToString:@"$0.00"]){
                [reqDict setObject:[userDict objectForKey:@"FName"] forKey:@"cc_first_name"];
                [reqDict setObject:[userDict objectForKey:@"LName"] forKey:@"cc_last_name"];
                [reqDict setObject:[userDict objectForKey:@"Street"] forKey:@"cc_address1"];
                [reqDict setObject:[userDict objectForKey:@"City"] forKey:@"cc_city"];
                [reqDict setObject:[userDict objectForKey:@"State"] forKey:@"cc_state"];
                [reqDict setObject:[userDict objectForKey:@"Country"] forKey:@"cc_country_code"];
                [reqDict setObject:[creditCardInfo objectForKey:@"CCZipcode"] forKey:@"cc_zipcode"];
                [reqDict setObject:[creditCardInfo objectForKey:@"CCNumber"] forKey:@"cc_num"];
                [reqDict setObject:[creditCardInfo objectForKey:@"CCCVV"] forKey:@"cc_cvv"];
                [reqDict setObject:[creditCardInfo objectForKey:@"CCExpires"] forKey:@"cc_expires"];
            }
        }
        [reqDict setObject:registrants forKey:@"registrants"];
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
        NSString *requestString = [NSString stringWithFormat:@"{\"primary_registration_id\": \"%@\",\"primary_confirmation_code\": \"%@\"}", [[info objectForKey:@"ConfirmationCodes"] objectForKey:@"PrimaryRegistrationID"], [[info objectForKey:@"ConfirmationCodes"] objectForKey:@"PrimaryConfirmationCode"]];
        
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
                        [cartItemDictionary setObject:[info text] forKey:@"Info"];
                        [cartItemDictionary setObject:[perItemCost text] forKey:@"PerItemCost"];
                        [cartItemDictionary setObject:[quantity text] forKey:@"Quanity"];
                        [cartItemDictionary setObject:[totalCost text] forKey:@"TotalCost"];

                    }
                    if([subitemsArray count] != 0)
                        [cartItemDictionary setObject:subitemsArray forKey:@"Subitems"];
                    
                    [cartArray addObject: cartItemDictionary];
                    [cartItemDictionary release];
                }
                
                if(baseCost && processingFee && totalCost){
                    [cartDictionary setObject:[baseCost text] forKey:@"BaseCost"];
                    [cartDictionary setObject:[processingFee text] forKey:@"ProcessingFee"];
                    [cartDictionary setObject:[totalCost text] forKey:@"TotalCost"];
                    
                    if([cartArray count] > 0){
                        [cartDictionary setObject: cartArray forKey:@"Cart"];
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, cartDictionary);});
                        return;
                    }
                }
            }else if(type == RSURegRegister){
                RXMLElement *primaryRegistrationID = [rootXML child: @"primary_registration_id"];
                RXMLElement *primaryConfirmationCode = [rootXML child: @"primary_confirmation_code"];
                
                if(primaryRegistrationID && primaryConfirmationCode){
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[primaryRegistrationID text] forKey:@"PrimaryRegistrationID"];
                    [dict setObject:[primaryConfirmationCode text] forKey:@"PrimaryConfirmationCode"];
                    
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
                [dict setObject:[errorCode text] forKey:@"ErrorCode"];
                [dict setObject:[errorMsg text] forKey:@"ErrorMessage"];
                
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, dict);});
                return;
            }else if(errorDetails){
                NSMutableArray *errorArray = [[NSMutableArray alloc] init];
                for(RXMLElement *error in [errorDetails children: @"error"]){
                    RXMLElement *message = [error child: @"error_msg"];
                    [errorArray addObject: [message text]];
                }
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidData, [NSDictionary dictionaryWithObject:errorArray forKey:@"ErrorArray"]);});
                return;
            }

        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

/*
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<request><registrants><registrant><user_id>%@</user_id>", [currentUser objectForKey: @"UserID"]];
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<first_name>%@</first_name><last_name>%@</last_name>", [currentUser objectForKey: @"FName"], [currentUser objectForKey: @"LName"]];
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<email>%@</email><address1>%@</address1>", [currentUser objectForKey:@"Email"], [currentUser objectForKey:@"Street"]];
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<city>%@</city><state>%@</state>", [currentUser objectForKey:@"City"], [currentUser objectForKey:@"State"]];
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<country_code>%@</country_code><zipcode>%@</zipcode>", [currentUser objectForKey:@"Country"], [currentUser objectForKey: @"Zipcode"]];
 xmlRequest = [xmlRequest stringByAppendingFormat:@"<phone>%@</phone><dob>%@</dob><gender>%@<gender><events>", [currentUser objectForKey:@"Phone"], [currentUser objectForKey:@"DOB"], [currentUser objectForKey:@"Gender"]];
 
 for(int x = 0; x < [[info objectForKey: @"Events"] count]; x++){
 
 }
 
 NSLog(@"Request: %@", xmlRequest);
 */

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
    if([currentUser objectForKey:@"UserID"] != nil && info != nil){
        NSString *newDob;
        NSString *oldDob = (NSString *)[info objectForKey:@"DOB"];
        if([oldDob length] == 10){
            newDob = [NSString stringWithFormat:@"%@-%@-%@", [oldDob substringWithRange:NSRangeFromString(@"6-4")], [oldDob substringWithRange:NSRangeFromString(@"0-2")], [oldDob substringWithRange:NSRangeFromString(@"3-2")]];
        }else{
            newDob = @"Error";
        }

        NSString *post = [NSString stringWithFormat:@"user_id=%@&first_name=%@&last_name=%@&dob=%@&gender=%@&phone=%@&address1=%@&city=%@&state=%@&country=%@&zipcode=%@",
                         [currentUser objectForKey:@"UserID"],[info objectForKey:@"FName"],[info objectForKey:@"LName"], newDob,
                         [info objectForKey:@"Gender"],[info objectForKey:@"Phone"],[info objectForKey:@"Street"],[info objectForKey:@"City"],
                         [info objectForKey:@"State"],[info objectForKey:@"Country"],[info objectForKey:@"Zipcode"]];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSString *url = [NSString stringWithFormat:@"%@/rest/user/%@/?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL,  [currentUser objectForKey:@"UserID"], key, secret];
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
                                        [eventsArray addObject: [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[eventID text],@"EventID",[eventStartTime text],@"StartTime", nil]];
                                    }
                                }
                            }
                            
                            if(raceName != nil && raceID != nil && [eventsArray count] != 0){
                                NSString *curtailedName = [raceName text];
                                if([curtailedName length] > 34)
                                    curtailedName = [curtailedName substringToIndex: 33];
                                raceDict = [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[raceID text],@"RaceID",[raceNextDate text],@"NDate",[raceLastDate text],@"LDate",eventsArray,@"Events",nil];
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
    if([params objectForKey:@"Page"])
        urlString = [urlString stringByAppendingFormat:@"&page=%i", [[params objectForKey:@"Page"] intValue]];
    if([params objectForKey:@"Name"])
        urlString = [urlString stringByAppendingFormat:@"&name=%@", [params objectForKey:@"Name"]];
    if([params objectForKey:@"Dist"])
        urlString = [urlString stringByAppendingFormat:@"&min_distance=%@", [params objectForKey:@"Dist"]];
    if([params objectForKey:@"DistUnits"])
        urlString = [urlString stringByAppendingFormat:@"&distance_units=%@", [params objectForKey:@"DistUnits"]];
    if([params objectForKey:@"FromDate"]){
        NSString *oldFromDate = (NSString *)[params objectForKey:@"FromDate"];
        NSString *newFromDate;
        if([oldFromDate length] == 10){
            newFromDate = [NSString stringWithFormat:@"%@-%@-%@", [oldFromDate substringWithRange:NSRangeFromString(@"6-4")], [oldFromDate substringWithRange:NSRangeFromString(@"0-2")], [oldFromDate substringWithRange:NSRangeFromString(@"3-2")]];
        }else{
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            return;
        }
        urlString = [urlString stringByAppendingFormat:@"&start_date=%@", newFromDate];
    }
    if([params objectForKey:@"ToDate"]){
        NSString *oldToDate = (NSString *)[params objectForKey:@"FromDate"];
        NSString *newToDate;
        if([oldToDate length] == 10){
            newToDate = [NSString stringWithFormat:@"%@-%@-%@", [oldToDate substringWithRange:NSRangeFromString(@"6-4")], [oldToDate substringWithRange:NSRangeFromString(@"0-2")], [oldToDate substringWithRange:NSRangeFromString(@"3-2")]];
        }else{
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            return;
        }
        urlString = [urlString stringByAppendingFormat:@"&end_date=%@", newToDate];
    }
    if([params objectForKey:@"Country"])
        urlString = [urlString stringByAppendingFormat:@"&country=%@", [params objectForKey:@"Country"]];
    if([params objectForKey:@"State"])
        urlString = [urlString stringByAppendingFormat:@"&state=%@", [params objectForKey:@"State"]];

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
                
                [race setObject:[NSNumber numberWithBool: registrationOpen] forKey:@"RegistrationOpen"];
                
                if(raceID)
                    [race setObject:[raceID text] forKey:@"RaceID"];
                if(raceName)
                    [race setObject:[raceName text] forKey:@"Name"];
                if(raceDescription)
                    [race setObject:[raceDescription text] forKey:@"Description"];
                if(raceURL)
                    [race setObject:[raceURL text] forKey:@"URL"];
                if(raceNextDate && [[raceNextDate text] length])
                    [race setObject:[raceNextDate text] forKey:@"Date"];
                else if(raceLastDate)
                    [race setObject:[raceLastDate text] forKey:@"Date"];
                
                if(raceAddress){
                    RXMLElement *street = [raceAddress child: @"street"];
                    RXMLElement *city = [raceAddress child: @"city"];
                    RXMLElement *state = [raceAddress child: @"state"];
                    RXMLElement *zipcode = [raceAddress child: @"zipcode"];
                    RXMLElement *country = [raceAddress child: @"country_code"];
                    if(street && [street text])
                        [race setObject:[street text] forKey:@"AL1"];
                    if(city && state && zipcode && country)
                        [race setObject:[NSString stringWithFormat:@"%@ %@ %@, %@", [city text], [state text], [country text], [zipcode text]] forKey:@"AL2"];
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
                                                                    [eventRegPeriodOpens text], @"RegistrationOpens",
                                                                    [eventRegPeriodCloses text], @"RegistrationCloses",
                                                                    [eventRegPeriodFee text], @"RegistrationFee",
                                                                    [eventRegPeriodProcessingFee text], @"RegistrationProcessingFee",nil];
                                [eventRegPeriodsArray addObject: eventRegPeriodDict];
                            }
                        }
                        
                        if(eventID)
                            [event setObject:[eventID text] forKey:@"EventID"];
                        if(eventName)
                            [event setObject:[eventName text] forKey:@"Name"];
                        if(eventStartTime)
                            [event setObject:[eventStartTime text] forKey:@"StartTime"];
                        
                        [event setObject:eventRegPeriodsArray forKey:@"EventRegistrationPeriods"];
                        [eventsArray addObject: event];
                    }
                }
                [race setObject:eventsArray forKey:@"Events"];
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
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/rest/race?race_id=%@&include_waiver=T&include_giveaway_details=T&race_headings=T&race_links=T", RUNSIGNUP_BASE_URL, raceID]]];
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
            RXMLElement *raceRegistrationOpen = [rootXML child:@"is_registration_open"];
            
            BOOL registrationOpen = NO;
            if(raceRegistrationOpen != nil && [[raceRegistrationOpen text] isEqualToString:@"T"])
                registrationOpen = YES;
            
            [race setObject:[NSNumber numberWithBool: registrationOpen] forKey:@"RegistrationOpen"];
            
            if(raceID)
                [race setObject:[raceID text] forKey:@"RaceID"];
            if(raceName)
                [race setObject:[raceName text] forKey:@"Name"];
            if(raceDescription)
                [race setObject:[raceDescription text] forKey:@"Description"];
            if(raceWaiver)
                [race setObject:[raceWaiver text] forKey:@"Waiver"];
            if(raceURL)
                [race setObject:[raceURL text] forKey:@"URL"];
            if(raceNextDate && [[raceNextDate text] length])
                [race setObject:[raceNextDate text] forKey:@"Date"];
            else if(raceLastDate)
                [race setObject:[raceLastDate text] forKey:@"Date"];
            
            if(raceAddress){
                RXMLElement *street = [raceAddress child: @"street"];
                RXMLElement *city = [raceAddress child: @"city"];
                RXMLElement *state = [raceAddress child: @"state"];
                RXMLElement *zipcode = [raceAddress child: @"zipcode"];
                RXMLElement *country = [raceAddress child: @"country_code"];
                if(street && [street text])
                    [race setObject:[street text] forKey:@"AL1"];
                if(city && state && zipcode && country)
                    [race setObject:[NSString stringWithFormat:@"%@ %@ %@, %@", [city text], [state text], [country text], [zipcode text]] forKey:@"AL2"];
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
                                                                [eventRegPeriodOpens text], @"RegistrationOpens",
                                                                [eventRegPeriodCloses text], @"RegistrationCloses",
                                                                [eventRegPeriodFee text], @"RegistrationFee",
                                                                [eventRegPeriodProcessingFee text], @"RegistrationProcessingFee",nil];
                            [eventRegPeriodsArray addObject: eventRegPeriodDict];
                        }
                    }
                    
                    for(RXMLElement *eventGiveawayOption in [eventGiveawayOptions children:@"giveaway_option"]){
                        RXMLElement *eventGiveawayOptionID = [eventGiveawayOption child: @"giveaway_option_id"];
                        RXMLElement *eventGiveawayOptionText = [eventGiveawayOption child: @"giveaway_option_text"];
                        RXMLElement *eventGiveawayAdditionalCost = [eventGiveawayOption child: @"additional_cost"];
                        
                        if(eventGiveawayOptionID && eventGiveawayOptionText && eventGiveawayAdditionalCost){
                            NSDictionary *eventGiveawayOptionDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     [eventGiveawayOptionID text], @"GiveawayOptionID",
                                                                     [eventGiveawayOptionText text], @"GiveawayOptionText",
                                                                     [eventGiveawayAdditionalCost text], @"GiveawayAdditionalCost", nil];
                            [eventGiveawayOptionsArray addObject: eventGiveawayOptionDict];
                        }
                    }
                    
                    if(eventID)
                        [event setObject:[eventID text] forKey:@"EventID"];
                    if(eventName)
                        [event setObject:[eventName text] forKey:@"Name"];
                    if(eventStartTime)
                        [event setObject:[eventStartTime text] forKey:@"StartTime"];
                    if(eventGiveaway)
                        [event setObject:[eventGiveaway text] forKey:@"Giveaway"];
                    
                    [event setObject:eventRegPeriodsArray forKey:@"EventRegistrationPeriods"];
                    if([eventGiveawayOptionsArray count] != 0)
                        [event setObject:eventGiveawayOptionsArray forKey:@"EventGiveawayOptions"];
                    [eventsArray addObject: event];
                }
            }
            [race setObject:eventsArray forKey:@"Events"];
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(race);});
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)retrieveUserInfo:(void (^)(RSUConnectionResponse))responseBlock{
    if(!signedIn){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%@/rest/user/%@/?tmp_key=%@&tmp_secret=%@&include_secondary_users=T", RUNSIGNUP_BASE_URL, [currentUser objectForKey:@"UserID"], key, secret];
        
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
        
        if(userID){
            [userDict setObject:[userID text] forKey:@"UserID"];
        }
        if(fname){
            [userDict setObject:[fname text] forKey:@"FName"];
        }
        if(lname){
            [userDict setObject:[lname text] forKey:@"LName"];
        }
        if(emailAddress){
            [userDict setObject:[emailAddress text] forKey:@"Email"];
        }
        if(gender){
            [userDict setObject:[gender text] forKey:@"Gender"];
        }
        if(phone){
            [userDict setObject:[phone text] forKey:@"Phone"];
        }
        if(profileImage)
            [userDict setObject:[profileImage text] forKey:@"ProfileImage"];
        if(dob){
            NSArray *dateParts = [[dob text] componentsSeparatedByString:@"/"];
            if([dateParts count] == 3){
                NSString *realDob = [NSString stringWithFormat:@"%02d/%02d/%04d", [[dateParts objectAtIndex: 0] intValue], [[dateParts objectAtIndex: 1] intValue], [[dateParts objectAtIndex: 2] intValue]];
                [userDict setObject:realDob forKey:@"DOB"];
            }else{
                [userDict setObject:[dob text] forKey:@"DOB"];
            }
        }
        if(address){
            RXMLElement *street = [address child:@"street"];
            RXMLElement *city = [address child:@"city"];
            RXMLElement *state = [address child:@"state"];
            RXMLElement *zipcode = [address child:@"zipcode"];
            RXMLElement *country = [address child:@"country_code"];
            
            if(street){
                [userDict setObject:[street text] forKey:@"Street"];
            }
            if(city){
                [userDict setObject:[city text] forKey:@"City"];
            }
            if(state){
                [userDict setObject:[state text] forKey:@"State"];
            }
            if(zipcode){
                [userDict setObject:[zipcode text] forKey:@"Zipcode"];
            }
            if(country){
                [userDict setObject:[country text] forKey:@"Country"];
            }
        }
        
        RXMLElement *secondaryUsers = [user child: @"secondary_users"];
        if(secondaryUsers){
            NSMutableArray *secondaryUsersArray = [[NSMutableArray alloc] init];

            for(RXMLElement *secondaryUser in [secondaryUsers children: @"user"]){
                NSMutableDictionary *secondaryUserDict = [self parseUser: secondaryUser];
                [secondaryUsersArray addObject: secondaryUserDict];
                [secondaryUserDict release];
            }
            [userDict setObject:secondaryUsersArray forKey:@"SecondaryUsers"];
        }
        
        return userDict;
    }else{
        return nil;
    }
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end