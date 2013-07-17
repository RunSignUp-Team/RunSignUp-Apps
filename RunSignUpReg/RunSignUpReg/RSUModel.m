//
//  RSUModel.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSUModel.h"

static RSUModel *model = nil;

@implementation RSUModel
@synthesize apiKey;
@synthesize apiSecret;
@synthesize key;
@synthesize secret;
@synthesize email;
@synthesize password;
@synthesize signedIn;
@synthesize lastParsedUser;

- (id)init{
    self = [super init];
    if(self){
        self.apiKey = API_KEY; // oauth @"3a90690eafbe965ae0b05a4769945a31401ed239";
        self.apiSecret = API_SECRET; // oauth @"f741ac1aa027a758618f5b032777f4bb3b7999dc";
        self.key = nil;
        self.secret = nil;
        self.email = nil;
        self.password = nil;
        self.signedIn = NO;
        self.lastParsedUser = nil;
    }
    return self;
}

/* Attempt to log in with the given email and password. Multiple responses
 can be returned: no connection, invalid email, invalid pass, success. If
 successful, then the secret and key are stored inside the RSUModel object. */
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock{
    self.email = em;
    self.password = pa;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", em, pa];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@/rest/login", RUNSIGNUP_BASE_URL]]];
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
            [self parseUser: user];
            
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
    if([lastParsedUser objectForKey:@"UserID"] != nil && info != nil){
        NSString *newDob;
        NSString *oldDob = (NSString *)[info objectForKey:@"DOB"];
        if([oldDob length] == 10){
            newDob = [NSString stringWithFormat:@"%@-%@-%@", [oldDob substringWithRange:NSRangeFromString(@"6-4")], [oldDob substringWithRange:NSRangeFromString(@"0-2")], [oldDob substringWithRange:NSRangeFromString(@"3-2")]];
        }else{
            newDob = @"Error";
        }

        NSString *post = [NSString stringWithFormat:@"user_id=%@&first_name=%@&last_name=%@&dob=%@&gender=%@&phone=%@&address1=%@&city=%@&state=%@&country=%@&zipcode=%@",
                         [lastParsedUser objectForKey:@"UserID"],[info objectForKey:@"FName"],[info objectForKey:@"LName"], newDob,
                         [info objectForKey:@"Gender"],[info objectForKey:@"Phone"],[info objectForKey:@"Street"],[info objectForKey:@"City"],
                         [info objectForKey:@"State"],[info objectForKey:@"Country"],[info objectForKey:@"Zipcode"]];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSString *url = [NSString stringWithFormat:@"https://%@/rest/user/%@/?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL,  [lastParsedUser objectForKey:@"UserID"], key, secret];
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
        NSString *url = [NSString stringWithFormat:@"https://%@/rest/races?tmp_key=%@&tmp_secret=%@&events=T", RUNSIGNUP_BASE_URL, key, secret];
        
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
    NSString *urlString = [NSString stringWithFormat: @"https://test.%@/rest/races?events=T&race_headings=T&race_links=T&sort=date+ASC,name+ASC", RUNSIGNUP_BASE_URL];
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

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&api_key=%@&api_secret=%@", urlString, apiKey, apiSecret]]];
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

/* Renew credentials every X amount of time so the user does not get logged out due to
 inactivity. */
- (int)renewCredentials{
    NSString *url = [NSString stringWithFormat:@"https://%@/rest/user?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL, key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(urlData){
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if(![[rootXML tag] isEqualToString:@"user"]){
            //int attempt = [self attemptLoginWithEmail:email pass:password];
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
    NSString *url = [NSString stringWithFormat:@"https://%@/rest/logout?tmp_key=%@&tmp_secret=%@", RUNSIGNUP_BASE_URL, key, secret];
    
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

- (void)parseUser:(RXMLElement *)user{
    if([[user tag] isEqualToString:@"user"]){
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        RXMLElement *userID = [user child:@"user_id"];
        RXMLElement *fname = [user child:@"first_name"];
        RXMLElement *lname = [user child:@"last_name"];
        RXMLElement *emailAddress = [user child:@"email"];
        RXMLElement *gender = [user child:@"gender"];
        RXMLElement *phone = [user child:@"phone"];
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
        if(dob){
            // Convert from yyyy-MM-dd to MM/dd/yyyy
            if([[dob text] length] == 10){
                NSString *realDob = [[dob text] substringWithRange:NSMakeRange(5, 2)];
                realDob = [realDob stringByAppendingFormat:@"/%@/%@", [[dob text] substringWithRange:NSMakeRange(8, 2)], [[dob text] substringWithRange:NSMakeRange(0, 4)]];
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
        self.lastParsedUser = userDict;
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