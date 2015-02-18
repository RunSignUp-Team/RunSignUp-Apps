//
//  RaceListViewController.m
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

#import "RaceListViewController.h"
#import "RaceDetailsViewController.h"
#import "RaceShallowDetailsViewController.h"
#import "RaceTableViewCell.h"
#import "RSUModel.h"
#import "RaceSearchTableViewCell.h"

@implementation RaceListViewController
@synthesize table;
@synthesize searchTable;
@synthesize toggleSearchButton;
@synthesize distanceDrop;
@synthesize countryDrop;
@synthesize stateDrop;
@synthesize distanceDropTriangle;
@synthesize countryDropTriangle;
@synthesize stateDropTriangle;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize currentLocationButton;
@synthesize raceNameField;
@synthesize distanceField;
@synthesize fromDateField;
@synthesize toDateField;
@synthesize toolbar;
@synthesize dateClearButton;
@synthesize prevNextControl;
@synthesize pickerBackgroundView;
@synthesize distancePicker;
@synthesize cityField;
@synthesize countryPicker;
@synthesize statePicker;
@synthesize datePicker;
@synthesize currentSearch;
@synthesize searchParams;
@synthesize raceList;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Race Calendar";
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:[[UIScreen mainScreen] bounds].size.width / 2 - 80 YLocation:80];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching List..."];
        
        currentPicker = 0;
        currentSelectedDistance = 0;
        currentSelectedCountry = 1;
        currentSelectedState = 0;
        
        page = 1;
        
        showingBackground = NO;
        showingAdvancedSearch = NO;
        firstLoad = YES;
        
        // If screen is iphone 4 or below sized, make advanced search fit into screen. Otherwise take up more room
        if([[UIScreen mainScreen] applicationFrame].size.height > 500)
            advancedSearchHeight = 460;
        else
            advancedSearchHeight = 374;
        
        searchOpen = NO;
        self.currentSearch = nil;
        
        self.searchParams = [[NSMutableDictionary alloc] init];
        moreResultsToRetrieve = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview: rli];
    [rli release];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [self.table addSubview: refreshControl];
    [refreshControl addTarget:self action:@selector(reloadRaces) forControlEvents:UIControlEventValueChanged];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        [prevNextControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:16]} forState:UIControlStateNormal];
    }else{
        [prevNextControl setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"OpenSans" size:16]} forState:UIControlStateNormal];
    }
    
    distanceArray = [[NSArray alloc] initWithObjects: @"Distance Units", @"Kilometers", @"Miles", @"Yards", @"Meters", nil];
    countryArray = [[NSArray alloc] initWithObjects: @"Country", @"United States", @"Canada", @"France", @"Germany", nil];
    stateArrayUS = [[NSArray alloc] initWithObjects: @"State", @"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE",
                    @"FL", @"GA", @"HA", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA",
                    @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND",
                    @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA",
                    @"WV", @"WI", @"WY", nil];
    stateArrayCA = [[NSArray alloc] initWithObjects: @"State", @"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"ON", @"PE", @"QC", @"SK", nil];
    stateArrayGE = [[NSArray alloc] initWithObjects: @"State", @"BB", @"BE", @"BW", @"BY", @"HB", @"HE", @"HH", @"MV", @"NI", @"NW", @"RP", @"SH",
                    @"SL", @"SN", @"ST", @"TH", nil];
    
    stateArrayUSReadable = [[NSArray alloc] initWithObjects: @"State", @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California",
                    @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois",
                    @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts",
                    @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada",
                    @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota",
                    @"Ohio",@"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina",
                    @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
    stateArrayCAReadable = [[NSArray alloc] initWithObjects: @"State", @"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                    @"Newfoundland and Labrador", @"Nova Scotia", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", nil];
    
    UIImage *darkBlueButtonImage = [UIImage imageNamed:@"DarkBlueButton.png"];
    UIImage *stretchedDarkBlueButton = [darkBlueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *orangeButtonImage = [UIImage imageNamed:@"OrangeButtonFilled.png"];
    UIImage *stretchedOrangeButton = [orangeButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];

    [searchButton setBackgroundImage:stretchedOrangeButton forState:UIControlStateNormal];
    [[searchButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:24]];
    
    for(UITextField *field in @[raceNameField,distanceField,cityField,fromDateField,toDateField]){
        [field setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
    }
    
    for(UIButton *button in @[distanceDrop, stateDrop, countryDrop]){
        [[button titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
    }
    
    [[toggleSearchButton titleLabel] setFont: [UIFont fontWithName:@"OpenSans" size:16]];
    
    dateFieldOriginalTextColor = [[fromDateField textColor] retain];
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObject: dateClearButton];
    [toolbar setItems: items];
    
    NSString *countryTitle = [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]];
    [countryDrop setTitle:countryTitle forState:UIControlStateNormal];
    [countryPicker selectRow:currentSelectedCountry inComponent:0 animated:NO];
    
    // Get ready to place search table into headerview
    [searchTable removeFromSuperview];
    [table setBackgroundView: nil];
    [table setBackgroundColor: [UIColor colorWithRed:231/255.0 green:239/255.0 blue:248/255.0 alpha:1.0]];
    
    //[table setContentOffset: CGPointMake(0, 44) animated:YES];
    
    [self retrieveRaceList];
}

- (void)updateRaceListsIfNecessary{
    int numberResults = RESULTS_PER_PAGE * page;
    
    int raceIndex = 0;
    
    NSDictionary *raceData = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy"];
    
    BOOL needMoreResults = NO;
    
    for(int i = 0; i < numberResults; i++){
        raceData = nil;
        NSDate *raceDate = nil;
        
        if(raceIndex < [raceList count]){
            raceData = [raceList objectAtIndex: raceIndex];
            
            if([raceData objectForKey: @"next_date"] != nil)
                raceDate = [formatter dateFromString: [raceData objectForKey: @"next_date"]];
            else
                raceDate = [formatter dateFromString: [raceData objectForKey: @"last_date"]];
            
            raceIndex++;
        }else{
            needMoreResults = YES;
        }
    }
    
    
    if(needMoreResults && moreResultsToRetrieve){
        NSLog(@"\n\nRetrieving 25 more runsignup");
        int currentPage = [[searchParams objectForKey: @"page"] intValue];
        if(moreResultsToRetrieve){
            currentPage++;
            [searchParams setObject:@(currentPage) forKey:@"page"];
            [self retrieveRaceListAndAppend];
        }
    }
}

- (void)readSearchParamsIntoControls{
    if(searchParams != nil){
        if([searchParams objectForKey:@"name"])
            [raceNameField setText:[searchParams objectForKey:@"name"]];
        if([searchParams objectForKey:@"min_distance"])
            [distanceField setText:[searchParams objectForKey:@"min_distance"]];
        if([searchParams objectForKey:@"start_date"])
            [fromDateField setText: [searchParams objectForKey:@"start_date"]];
        if([searchParams objectForKey:@"end_date"])
            [toDateField setText: [searchParams objectForKey:@"end_date"]];
        if([searchParams objectForKey:@"distance_units"]){
            NSString *distanceUnits = [searchParams objectForKey:@"distance_units"];
            if([distanceUnits isEqualToString: @"K"])
                currentSelectedDistance = 1;
            else if([distanceUnits isEqualToString: @"M"])
                currentSelectedDistance = 2;
            else if([distanceUnits isEqualToString: @"Y"])
                currentSelectedDistance = 3;
            else
                currentSelectedDistance = 4;
            
            NSString *distanceType = [distanceArray objectAtIndex: currentSelectedDistance];
            [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", distanceType] forState:UIControlStateNormal];
            [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", distanceType] forState:UIControlStateSelected];
            [distancePicker selectRow:currentSelectedDistance inComponent:0 animated:NO];
        }
        if([searchParams objectForKey:@"country_code"]){
            NSString *country = [searchParams objectForKey:@"country_code"];
            if([country isEqualToString:@"US"])
                currentSelectedCountry = 1;
            else if([country isEqualToString:@"CA"])
                currentSelectedCountry = 2;
            else if([country isEqualToString:@"FR"])
                currentSelectedCountry = 3;
            else
                currentSelectedCountry = 4;
            
            NSString *countryTitle = [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]];
            [countryDrop setTitle:countryTitle forState:UIControlStateNormal];
            [countryPicker selectRow:currentSelectedCountry inComponent:0 animated:NO];
            
            if([searchParams objectForKey:@"state"] && currentSelectedCountry != 3){
                NSArray *currentStateArray = stateArrayUS;
                if(currentSelectedCountry == 2)
                    currentStateArray = stateArrayCA;
                else if(currentSelectedCountry == 4)
                    currentStateArray = stateArrayGE;
                
                int index = 0;
                for(NSString *state in currentStateArray){
                    if([state isEqualToString:[searchParams objectForKey:@"state"]]){
                        [stateDrop setTitle:[NSString stringWithFormat:@"  %@", state] forState:UIControlStateNormal];
                        [stateDrop setTitle:[NSString stringWithFormat:@"  %@", state] forState:UIControlStateSelected];
                        [statePicker selectRow:index inComponent:0 animated:NO];
                        currentSelectedState = index;
                        break;
                    }
                    index++;
                }
            }else{
                [stateDrop setTitle:@"" forState:UIControlStateNormal];
                [stateDrop setTitle:@"" forState:UIControlStateSelected];
            }
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (IBAction)search:(id)sender{
    NSString *name = [raceNameField text];
    NSString *distance = [distanceField text];
    NSString *city = [cityField text];
    NSString *fromDate = [fromDateField text];
    NSString *toDate = [toDateField text];
    
    NSString *distancePick = nil;
    if(currentSelectedDistance == 1)
        distancePick = @"K";
    else if(currentSelectedDistance == 2)
        distancePick = @"M";
    else if(currentSelectedDistance == 3)
        distancePick = @"Y";
    else if(currentSelectedDistance == 4)
        distancePick = @"m";
    
    NSString *countryPick = nil;
    NSArray *stateArray = nil;
    if(currentSelectedCountry == 1){
        countryPick = @"US";
        stateArray = stateArrayUS;
    }else if(currentSelectedCountry == 2){
        countryPick = @"CA";
        stateArray = stateArrayCA;
    }else if(currentSelectedCountry == 3){
        countryPick = @"FR";
    }else if(currentSelectedCountry == 4){
        countryPick = @"GE";
        stateArray = stateArrayGE;
    }
    
    NSString *statePick = nil;
    if(currentSelectedState != 0 && stateArray != nil)
        statePick = [stateArray objectAtIndex: currentSelectedState];
    
    // NOT ENOUGH, ONLY CHECKS IF STARTS WITH A-Z, NOT WHOLE STRING
    // Race name length
    // Distance characters as stated above
    // If distance specified, make sure distance units specified. Not necessarily vice versa
    //
    
    if([distance length] && [distance doubleValue] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid distance, please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }else if([distance length] == 0)
        distance = nil;
    
    if([name length] == 0)
        name = nil;
    
    if([city length] == 0)
        city = nil;
    
    /*if([fromDate length] == 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        fromDate = [formatter stringFromDate: [NSDate date]];
        [formatter release];
    }*/
    
    if([fromDate length] == 0)
        fromDate = nil;
    
    if([toDate length] == 0)
        toDate = nil;
    
    NSMutableDictionary *newSearchParams = [[NSMutableDictionary alloc] init];
    [newSearchParams setObject:@"1" forKey:@"page"];
    if(name)[newSearchParams setObject:name forKey:@"name"];
    if(distance)[newSearchParams setObject:distance forKey:@"min_distance"];
    if(distancePick)[newSearchParams setObject:distancePick forKey:@"distance_units"];
    if(city)[newSearchParams setObject:city forKey:@"city"];
    if(fromDate)[newSearchParams setObject:fromDate forKey:@"start_date"];
    if(toDate)[newSearchParams setObject:toDate forKey:@"end_date"];
    if(countryPick)[newSearchParams setObject:countryPick forKey:@"country_code"];
    if(statePick)[newSearchParams setObject:statePick forKey:@"state"];
    
    NSLog(@"%@", newSearchParams);
    
    if(showingAdvancedSearch)
        [self toggleAdvancedSearch: nil];
    [self hideBackground];
    [self setSearchParams: newSearchParams];
    
    searchOpen = NO;
    self.currentSearch = nil;
    
    [self retrieveRaceList];
}

- (void)retrieveRaceList{
    [[rli label] setText: @"Fetching List..."];
    [rli fadeIn];
    
    if(!firstLoad && [raceList count] > 0)
        [rli setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
    else{
        [rli setBackgroundColor: [UIColor whiteColor]];
        firstLoad = NO;
    }
    
    raceList = nil;
    loadedRaces = NO;
    
    page = 1;
    
    void (^response)(NSArray *) = ^(NSArray *list){
        loadedRaces = YES;
        moreResultsToRetrieve = YES;
        if(list == nil || [list count] < 25)
            moreResultsToRetrieve = NO;
        
        self.raceList = list;
    
        NSLog(@"#Races: %i", [raceList count]);
        [rli fadeOut];
        [self doneLoadingRaces];
        
    };
    
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (void)retrieveRaceListAndAppend{
    [[rli label] setText: @"Fetching List..."];
    [rli fadeIn];
    
    if(!firstLoad && [raceList count] > 0)
        [rli setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
    else{
        [rli setBackgroundColor: [UIColor whiteColor]];
        firstLoad = NO;
    }
    
    void (^response)(NSArray *) = ^(NSArray *list){
        if(list == nil || [list count] == 0){
            // Page retrieval returned empty - reset page number
            moreResultsToRetrieve = NO;
            int currentPage = [[searchParams objectForKey:@"page"] intValue];
            [searchParams setObject:[NSString stringWithFormat:@"%i", MAX(currentPage - 1, 0)] forKey:@"page"];
        }else if([list count] < 25)
            moreResultsToRetrieve = NO;
        
        int oldCount = [raceList count];
        NSMutableArray *newRaceList = [[NSMutableArray alloc] initWithArray:raceList];
        [newRaceList addObjectsFromArray: list];
        self.raceList = newRaceList;
        [rli fadeOut];
        searchOpen = NO;
        self.currentSearch = nil;
        
        if([raceList count] != oldCount){
            UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldCount inSection:0]];
            [cell setAlpha: 0.0f];
            [UIView beginAnimations:@"Cell Fade" context:nil];
            [UIView setAnimationDuration: 0.75f];
            [cell setAlpha: 1.0f];
            [UIView commitAnimations];
        }
        
        [self doneLoadingRaces];
    };
    
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (IBAction)useCurrentLocation:(id)sender{
    if([CLLocationManager locationServicesEnabled]){
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        [manager setDelegate: self];
        [manager setDistanceFilter: kCLDistanceFilterNone];
        [manager setDesiredAccuracy: kCLLocationAccuracyHundredMeters];
        [manager startUpdatingLocation];
        
        numLocationUpdates = 0;
        [[rli label] setText: @"Fetching Info..."];
        [rli fadeIn];
        [rli setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
        // ^^ In case it hasn't been reset by a retrieveRaceList(andAppend) call
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location services are disabled. Please go to Settings and turn on Location Services for this application." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newPos = [locations lastObject];

    [self getReverseGeocodeFromLocation: newPos];
    
    numLocationUpdates++;
    
    if(numLocationUpdates > 3){
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    [rli fadeOut];
    
    NSLog(@"Error: %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location services are disabled. Please go to Settings and turn on Location Services for this application." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)getReverseGeocodeFromLocation:(CLLocation *)loc{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        [rli fadeOut];
        
        if(error || [placemarks count] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not get address from current location. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            return;
        }else{
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *city = [[placemark addressDictionary] objectForKey: @"City"];
            NSString *state = [[placemark addressDictionary] objectForKey: @"State"];
            NSString *country = [[placemark addressDictionary] objectForKey: @"Country"];
            
            if(city){
                [cityField setText: city];
            }
           
            if(country){
                NSArray *currentStateArray = nil;
                for(int i = 0; i < [countryArray count]; i++){
                    if([country isEqualToString: [countryArray objectAtIndex: i]]){
                        currentSelectedCountry = i;
                        
                        if(currentSelectedCountry == 1)
                            currentStateArray = stateArrayUS;
                        else if(currentSelectedCountry == 2)
                            currentStateArray = stateArrayCA;
                        else if(currentSelectedCountry == 4)
                            currentStateArray = stateArrayGE;
                        
                        [countryPicker selectRow:i inComponent:0 animated:NO];
                        [countryDrop setTitle:[NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: i]] forState:UIControlStateNormal];
                        [countryDrop setTitle:[NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: i]] forState:UIControlStateSelected];
                    }
                }
                
                if(state){
                    if(currentStateArray != nil){
                        for(int i = 0; i < [currentStateArray count]; i++){
                            if([state isEqualToString: [currentStateArray objectAtIndex: i]]){
                                currentSelectedState = i;
                                [statePicker selectRow:i inComponent:0 animated:YES];
                                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [currentStateArray objectAtIndex: i]] forState:UIControlStateNormal];
                                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [currentStateArray objectAtIndex: i]] forState:UIControlStateSelected];
                            }
                        }
                    }
                }
            }
                
        }
    }];
}

- (void)searchFieldDidBeginEdit{
    searchOpen = YES;
    self.currentSearch = nil;
}

- (void)searchFieldDidEditText:(NSString *)text{
    searchOpen = YES;
    self.currentSearch = [NSString stringWithString: text];
    
    NSLog(@"Current search: %@", currentSearch);
}


- (void)searchFieldDidCancel{
    searchOpen = NO;
    self.currentSearch = nil;
    
    if(showingAdvancedSearch)
        [self toggleAdvancedSearch: nil];
}

- (void)searchButtonTappedWithSearch:(NSString *)search{
    self.searchParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:search, @"name", nil];
    searchOpen = NO;
    self.currentSearch = nil;

    [self retrieveRaceList];
    if(showingAdvancedSearch)
        [self toggleAdvancedSearch: nil];
}

- (IBAction)hidePicker:(id)sender{
    [self hideCurrentPicker: YES];
    [self.view endEditing: YES];
    [self hideBackground];
}

- (void)hideCurrentPicker:(BOOL)animated{
    if(currentPicker != 0){
        UIPickerView *pickerToAnimate = nil;
        UIButton *currentDrop = nil;
        UIImageView *currentDropTriangle = nil;
        if(currentPicker == 1){
            pickerToAnimate = distancePicker;
            currentDrop = distanceDrop;
            currentDropTriangle = distanceDropTriangle;
        }else if(currentPicker == 2){
            pickerToAnimate = statePicker;
            currentDrop = stateDrop;
            currentDropTriangle = stateDropTriangle;
        }else if(currentPicker == 3){
            pickerToAnimate = countryPicker;
            currentDrop = countryDrop;
            currentDropTriangle = countryDropTriangle;
        }else if(currentPicker == 4 || currentPicker == 5){
            [UIView beginAnimations:@"DatePickerSlide" context:nil];
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
            [UIView commitAnimations];
            
            currentPicker = 0;
            return;
        }
        
        [currentDrop setSelected: NO];
        [currentDropTriangle setHighlighted: NO];
        
        if(animated)
            [UIView beginAnimations:@"PickerSlide" context:nil];
        [pickerToAnimate setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
        if(animated)
            [UIView commitAnimations];
        
        currentPicker = 0;
    }
}

- (void)showDatePickerForFromDateField:(BOOL)from{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    if(searchOpen){
        searchOpen = NO;
        self.currentSearch = nil;
    }
    
    [self showBackground];
    
    [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:7 inSection:0]];

    NSMutableArray *items = [[toolbar items] mutableCopy];
    if(![items containsObject: dateClearButton])
        [items insertObject:dateClearButton atIndex:1];
    [toolbar setItems: items];
    
    NSDate *currentDate = [NSDate date];
    if(from){
        if([[fromDateField text] length] > 0){
            currentDate = [dateFormatter dateFromString: [fromDateField text]];
        }
        [fromDateField setTextColor: [UIColor blackColor]];
    }else{ // to date field
        if([[toDateField text] length] > 0){
            currentDate = [dateFormatter dateFromString: [toDateField text]];
        }
        [toDateField setTextColor: [UIColor blackColor]];
    }
    
    [datePicker setDate: currentDate];
    
    if(currentPicker != 4 && currentPicker != 5){
        [distanceDrop setSelected: NO];
        [countryDrop setSelected: NO];
        [stateDrop setSelected: NO];
        
        if(currentPicker != 0){
            [self hideCurrentPicker: NO];
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
        }else{
            [self.view endEditing: YES];
            [UIView beginAnimations:@"DatePickerSlide" context:nil];
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
            [UIView commitAnimations];
        }
    }
    
    if(from)
        currentPicker = 4;
    else
        currentPicker = 5;
    
    [self datePickerDidChange: nil];
}

- (void)scrollTableToSearchTableRow:(NSIndexPath *)row{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGRect searchTableRect = [searchTable rectForRowAtIndexPath: row];
        float offset = 0;
        if([[UIScreen mainScreen] applicationFrame].size.height > 500)
            offset = MAX(searchTableRect.origin.y - 64, 0);
        else
            offset = MAX(searchTableRect.origin.y - 24, 0);

        [table setContentOffset:CGPointMake(0, offset) animated:YES];
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showBackground];
    
    if(searchOpen){
        searchOpen = NO;
        self.currentSearch = nil;
    }
    
    if(textField == raceNameField){
        [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:1 inSection:0]];
    }else if(textField == distanceField){
        [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:2 inSection:0]];
    }else if(textField == cityField){
        [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:4 inSection:0]];
    }else if(textField == fromDateField || textField == toDateField){
        [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:7 inSection:0]];
    }
    
    if(textField == fromDateField || textField == toDateField){
        if(textField == fromDateField){
            [self showDatePickerForFromDateField: YES];
        }else if(textField == toDateField){
            [self showDatePickerForFromDateField: NO];
        }
        
        return NO;
    }else{
        [self hideCurrentPicker: YES];
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == raceNameField)
        [distanceField becomeFirstResponder];
    else if(textField == distanceField)
        [self showDistancePicker: nil];
    else if(textField == cityField)
        [self showStatePicker: nil];
    
    return NO;
}

- (IBAction)datePickerDidChange:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    if(currentPicker == 4){
        [fromDateField setText: [dateFormatter stringFromDate: [datePicker date]]];
    }else if(currentPicker == 5){
        [toDateField setText: [dateFormatter stringFromDate: [datePicker date]]];
    }
    
    [dateFormatter release];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *rowText = nil;
    if(pickerView == distancePicker){
        rowText = [distanceArray objectAtIndex: row];
    }else if(pickerView == countryPicker){
        rowText = [countryArray objectAtIndex: row];
    }else{
        if(currentSelectedCountry == 1)
            rowText = [stateArrayUSReadable objectAtIndex: row];
        else if(currentSelectedCountry == 2)
            rowText = [stateArrayCAReadable objectAtIndex: row];
        else if(currentSelectedCountry == 4)
            rowText = [stateArrayGE objectAtIndex: row];
    }
    
    if(view == nil){
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, [self.view frame].size.width - 8, 22)];
        [label setTextAlignment: NSTextAlignmentCenter];
        [label setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setText: rowText];
        return label;
    }else{
        UILabel *label = (UILabel *)view;
        [label setText: rowText];
        return label;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == distancePicker)
        return [distanceArray count];
    else if(pickerView == countryPicker)
        return [countryArray count];
    else{
        if(currentSelectedCountry == 1)
            return [stateArrayUS count];
        else if(currentSelectedCountry == 2)
            return [stateArrayCA count];
        else if(currentSelectedCountry == 4)
            return [stateArrayGE count];
        else
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == distancePicker){
        currentSelectedDistance = row;
        [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", [distanceArray objectAtIndex: row]] forState:UIControlStateNormal];
        [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", [distanceArray objectAtIndex: row]] forState:UIControlStateSelected];
    
    }else if(pickerView == countryPicker){
        currentSelectedCountry = row;
        currentSelectedState = 0;
        [statePicker reloadAllComponents];
        
        if(currentSelectedCountry != 0 && currentSelectedCountry != 3)
            [statePicker setUserInteractionEnabled: YES];
        else
            [statePicker setUserInteractionEnabled: NO];
        
        NSString *countryTitle = [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: row]];
        
        [countryDrop setTitle:countryTitle forState:UIControlStateNormal];
        [countryDrop setTitle:countryTitle forState:UIControlStateSelected];

        NSString *stateTitle = nil;
        
        if(currentSelectedCountry == 0)
            stateTitle = @"";
        else if(currentSelectedCountry == 1)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayUSReadable objectAtIndex: 0]];
        else if(currentSelectedCountry == 2)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayCAReadable objectAtIndex: 0]];
        else if(currentSelectedCountry == 3)
            stateTitle = @"";
        else if(currentSelectedCountry == 4)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: 0]];
    
        [stateDrop setTitle:stateTitle forState:UIControlStateNormal];
        [stateDrop setTitle:stateTitle forState:UIControlStateSelected];
        
    }else{
        currentSelectedState = row;
        NSString *stateTitle = nil;
        
        if(currentSelectedCountry == 1)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayUS objectAtIndex: row]];
        else if(currentSelectedCountry == 2)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayCA objectAtIndex: row]];
        else if(currentSelectedCountry == 4)
            stateTitle = [NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: row]];
        
        [stateDrop setTitle:stateTitle forState:UIControlStateNormal];
        [stateDrop setTitle:stateTitle forState:UIControlStateSelected];
    }
}

- (IBAction)prevNextChanged:(id)sender{
    if(prevNextControl.selectedSegmentIndex == 0){
        if(currentPicker != 0){
            if(currentPicker == 1){
                [distanceField becomeFirstResponder];
            }else if(currentPicker == 2){
                [cityField becomeFirstResponder];
            }else if(currentPicker == 3){
                [self showStatePicker: nil];
            }else if(currentPicker == 4){
                [self showCountryPicker: nil];
            }else if(currentPicker == 5){
                [self showDatePickerForFromDateField: YES];
            }
            return;
        }
        
        for(UITextField *field in @[raceNameField,distanceField,cityField,fromDateField,toDateField]){
            if([field isFirstResponder]){
                if(field == distanceField)
                    [raceNameField becomeFirstResponder];
                else if(field == cityField)
                    [self showDistancePicker: nil];
                else if(field == fromDateField)
                    [self showCountryPicker: nil];
                else if(field == toDateField)
                    [self showDatePickerForFromDateField: YES];
                return;
            }
        }
    }else{
        if(currentPicker != 0){
            if(currentPicker == 1){
                [cityField becomeFirstResponder];
            }else if(currentPicker == 2){
                [self showCountryPicker: nil];
            }else if(currentPicker == 3){
                [self showDatePickerForFromDateField: YES];
            }else if(currentPicker == 4){
                [self showDatePickerForFromDateField: NO];
            }
            return;
        }
        
        for(UITextField *field in @[raceNameField,distanceField,cityField,fromDateField,toDateField]){
            if([field isFirstResponder]){
                if(field == raceNameField)
                    [distanceField becomeFirstResponder];
                else if(field == distanceField)
                    [self showDistancePicker: nil];
                else if(field == cityField)
                    [self showStatePicker: nil];
                else if(field == fromDateField)
                    [self showDatePickerForFromDateField: NO];
                return;
            }
        }
    }
}

- (IBAction)toggleAdvancedSearch:(id)sender{
    showingAdvancedSearch = !showingAdvancedSearch;
    if(showingAdvancedSearch){
        [toggleSearchButton setTitle:@"Hide Advanced Search" forState:UIControlStateNormal];
        [searchTable removeFromSuperview];
        [searchTable reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [table setContentOffset:CGPointMake(0, 44) animated:YES];
        });
    }else{
        [toggleSearchButton setTitle:@"Show Advanced Search" forState:UIControlStateNormal];
        [self hidePicker: nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [table setContentOffset:CGPointMake(0, 0) animated:YES];
        });
    }
    
    [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[table reloadSections:[NSIndexSet indexSetWithIndex: 0] withRowAnimation:UITableViewRowAnimationFade];
    //[searchTable reloadSections:[NSIndexSet indexSetWithIndex: 0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)clearDateField:(id)sender{
    if(currentPicker == 4 || currentPicker == 5){
        if(currentPicker == 4){
            [fromDateField setText: @""];
            [self hidePicker: nil];
        }else{
            [toDateField setText: @""];
            [self hidePicker: nil];
        }
    }
}

- (IBAction)showDistancePicker:(id)sender{
    [self.view endEditing: YES];
   
    if(searchOpen){
        searchOpen = NO;
        self.currentSearch = nil;
    }
    
    [distanceDrop setSelected: YES];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: NO];
    [distanceDropTriangle setHighlighted: YES];
    [countryDropTriangle setHighlighted: NO];
    [stateDropTriangle setHighlighted: NO];
    
    [self showBackground];
    
    [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:3 inSection:0]];
    
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
        [UIView commitAnimations];
        
    }else{
        [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
    }
    [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    
    currentPicker = 1;
}

- (IBAction)showStatePicker:(id)sender{
    [self.view endEditing: YES];
    
    if(searchOpen){
        searchOpen = NO;
        self.currentSearch = nil;
    }
    
    [distanceDrop setSelected: NO];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: YES];
    [distanceDropTriangle setHighlighted: NO];
    [countryDropTriangle setHighlighted: NO];
    [stateDropTriangle setHighlighted: YES];
    
    [self showBackground];
    
    [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:5 inSection:0]];
    
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
        [UIView commitAnimations];
        
    }else{
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
    }
    [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    
    currentPicker = 2;
}

- (IBAction)showCountryPicker:(id)sender{
    [self.view endEditing: YES];
    
    if(searchOpen){
        searchOpen = NO;
        self.currentSearch = nil;
    }
    
    [distanceDrop setSelected: NO];
    [countryDrop setSelected: YES];
    [stateDrop setSelected: NO];
    [distanceDropTriangle setHighlighted: NO];
    [countryDropTriangle setHighlighted: YES];
    [stateDropTriangle setHighlighted: NO];
    
    [self showBackground];
    
    [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:6 inSection:0]];
    
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, [self.view frame].size.width, 260)];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
        [UIView commitAnimations];
        
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, [self.view frame].size.width, 216)];
    }
    [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 216)];
    
    currentPicker = 3;
}

- (void)hideBackground{
    if(showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, [self.view frame].size.width, 260)];
        [UIView commitAnimations];
        showingBackground = NO;
    }
}

- (void)showBackground{
    [fromDateField setTextColor: dateFieldOriginalTextColor];
    [toDateField setTextColor: dateFieldOriginalTextColor];
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    if([items containsObject: dateClearButton])
        [items removeObject: dateClearButton];
    [toolbar setItems: items];
    
    if(!showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, [self.view frame].size.width, 260)];
        [UIView commitAnimations];
        showingBackground = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == searchTable){
        static NSString *SearchControlCellIdentifier = @"SearchControlCellIdentifier";
        
        RoundedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchControlCellIdentifier];
        float cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        if(cell == nil){
            cell = [[RoundedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchControlCellIdentifier];
        }
        
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        [cell setTop: NO];
        [cell setBottom: NO];
        [cell setExtra: NO];
        [cell setMiddleDivider: NO];
        [cell reset];
        [cell setCellHeight: cellHeight];
        
        if(indexPath.row == 0){
            if(toggleSearchButton.superview != nil)
                [toggleSearchButton removeFromSuperview];
            [toggleSearchButton setFrame: CGRectMake(20, 0, screenWidth - 40, cellHeight)];
            [cell.contentView addSubview: toggleSearchButton];
            [cell setExtra: YES];
        }else if(indexPath.row == 1){
            if(raceNameField.superview != nil)
                [raceNameField removeFromSuperview];
            [raceNameField setFrame: CGRectMake(36, 0, screenWidth - 72, cellHeight)];
            [cell.contentView addSubview: raceNameField];
            [cell setTop: YES];
        }else if(indexPath.row == 2){
            if(distanceField.superview != nil)
                [distanceField removeFromSuperview];
            [distanceField setFrame: CGRectMake(36, 0, screenWidth - 72, cellHeight)];
            [cell.contentView addSubview: distanceField];
        }else if(indexPath.row == 3){
            if(distanceDrop.superview != nil)
                [distanceDrop removeFromSuperview];
            if(distanceDropTriangle.superview != nil)
                [distanceDropTriangle removeFromSuperview];
            
            [distanceDrop setFrame: CGRectMake(28, 0, screenWidth - 60, cellHeight)];
            [distanceDropTriangle setFrame: CGRectMake(screenWidth - 65, cellHeight / 2 - distanceDropTriangle.frame.size.height / 2, distanceDropTriangle.frame.size.width, distanceDropTriangle.frame.size.height)];
            [cell.contentView addSubview: distanceDrop];
            [cell.contentView addSubview: distanceDropTriangle];
        }else if(indexPath.row == 4){
            if(cityField.superview != nil)
                [cityField removeFromSuperview];
            if(currentLocationButton.superview != nil)
                [currentLocationButton removeFromSuperview];
            
            [cityField setFrame: CGRectMake(36, 0, screenWidth - 130, cellHeight)];
            [currentLocationButton setFrame: CGRectMake(screenWidth - 90, 0, 70, cellHeight)];
            [cell.contentView addSubview: cityField];
            [cell.contentView addSubview: currentLocationButton];
        }else if(indexPath.row == 5){
            if(stateDrop.superview != nil)
                [stateDrop removeFromSuperview];
            if(stateDropTriangle.superview != nil)
                [stateDropTriangle removeFromSuperview];
            
            [stateDrop setFrame: CGRectMake(28, 0, screenWidth - 60, cellHeight)];
            [stateDropTriangle setFrame: CGRectMake(screenWidth - 65, cellHeight / 2 - stateDropTriangle.frame.size.height / 2, stateDropTriangle.frame.size.width, stateDropTriangle.frame.size.height)];
            [cell.contentView addSubview: stateDrop];
            [cell.contentView addSubview: stateDropTriangle];
        }else if(indexPath.row == 6){
            if(countryDrop.superview != nil)
                [countryDrop removeFromSuperview];
            if(countryDropTriangle.superview != nil)
                [countryDropTriangle removeFromSuperview];
            
            [countryDrop setFrame: CGRectMake(28, 0, screenWidth - 60, cellHeight)];
            [countryDropTriangle setFrame: CGRectMake(screenWidth - 65, cellHeight / 2 - countryDropTriangle.frame.size.height / 2, countryDropTriangle.frame.size.width, countryDropTriangle.frame.size.height)];

            [cell.contentView addSubview: countryDrop];
            [cell.contentView addSubview: countryDropTriangle];
        }else if(indexPath.row == 7){
            if(fromDateField.superview != nil)
                [fromDateField removeFromSuperview];
            if(toDateField.superview != nil)
                [toDateField removeFromSuperview];
            
            [fromDateField setFrame: CGRectMake(20, 0, screenWidth / 2 - 20, cellHeight)];
            [toDateField setFrame: CGRectMake(screenWidth / 2, 0, screenWidth / 2 - 20, cellHeight)];
            
            [cell.contentView addSubview: fromDateField];
            [cell.contentView addSubview: toDateField];
            
            [cell setMiddleDivider: YES];
        }else if(indexPath.row == 8){
            if(searchButton.superview != nil)
                [searchButton removeFromSuperview];
            
            [searchButton setFrame: CGRectMake(20, cellHeight / 2 - 22, screenWidth - 40, 44)];
            [cell.contentView addSubview: searchButton];
            [cell setExtra: YES];
        }
        
        return cell;
    }else{
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                static NSString *SearchCellIdentifier = @"SearchCellIdentifier";
                
                RaceSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
                if(cell == nil){
                    cell = [[RaceSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier];
                }
                
                [cell setDelegate: self];
                
                if(searchOpen){
                    [cell layoutActive: YES];
                    
                    // Delay becomeFirstResponder because otherwise the message gets lost
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [[cell searchField] setText: currentSearch];
                        [[cell searchField] becomeFirstResponder];
                    });
                }else{
                    [cell layoutActive: NO];
                }
                    
                return cell;
            }else{
                static NSString *SearchTableCellIdentifier = @"SearchTableCellIdentifier";
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTableCellIdentifier];
                if(cell == nil){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchTableCellIdentifier];
                }
                
                [cell.contentView.superview setClipsToBounds: YES];
                
                if(searchTable.superview != nil)
                    [searchTable removeFromSuperview];
                
                [cell.contentView addSubview:searchTable];
                
                return cell;
            }
        }else if(indexPath.section == 1){
            static NSString *RaceCellIdentifier = @"RaceCellIdentifier";

            RaceTableViewCell *cell = (RaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RaceCellIdentifier];
            if(cell == nil){
                cell = [[RaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RaceCellIdentifier];
            }
            
            if(indexPath.row % 2)
                [[cell contentView] setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
            else
                [[cell contentView] setBackgroundColor: [UIColor whiteColor]];
            
            NSDictionary *raceData = [raceList objectAtIndex: indexPath.row];
            
            if(raceData != nil){
                [cell setData: raceData];
            }
            
            /*UIImage *disclosureImage = [UIImage imageNamed:@"RaceListDisclosure.png"];
            UIImageView *disclosureImageView = [[UIImageView alloc] initWithImage: disclosureImage];
            [cell setAccessoryView: disclosureImageView];
            [[cell accessoryView] setBackgroundColor: [UIColor clearColor]];
            [disclosureImageView release];*/
            
            /*NSString *htmlString = [[raceList objectAtIndex: indexPath.row] objectForKey: @"description"];
            
            NSRange r;
            while((r = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                htmlString = [htmlString stringByReplacingCharactersInRange:r withString:@""];
            }
            
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h1>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h1>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h2>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h2>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h3>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h3>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h4>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h4>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h5>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h5>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<span>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</b>" withString:@""];

            [[cell descriptionLabel] setText: htmlString];
            */ 
            return cell;
        }else{
            static NSString *CellIdentifier = @"CellIdentifier";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            if(moreResultsToRetrieve || page * RESULTS_PER_PAGE < ([raceList count])){
                [[cell textLabel] setText:@"Show More..."];
                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
            }else if([raceList count]){
                [[cell textLabel] setText:@"All Results Loaded"];
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            }else{
                [[cell textLabel] setText:@"No Results Found"];
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            }
            
            [[cell textLabel] setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
            [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:18]];
            [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
            
            if([raceList count] % 2 || [raceList count] == 0){// || [self tableView:tableView numberOfRowsInSection: indexPath.section] == 1){
                [[cell contentView] setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
            }else{
                [[cell contentView] setBackgroundColor: [UIColor whiteColor]];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        NSDictionary *raceData = [raceList objectAtIndex: indexPath.row];
        
        RaceDetailsViewController *rdvc = [[RaceDetailsViewController alloc] initWithNibName:@"RaceDetailsViewController" bundle:nil data:raceData];
        [self.navigationController pushViewController:rdvc animated:YES];
        [rdvc release];
        
    }else if(indexPath.section == 2){        
        page++;
        [self updateRaceListsIfNecessary];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    int headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    //[header setBackgroundColor: [UIColor colorWithRed:0.5f green:0.6863f blue:0.8431f alpha:1.0f]];
    [header setBackgroundColor: [refreshHeaderView backgroundColor]];
    
    UIImageView *cancelIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CancelSearch.png"]];
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search.png"]];
    [cancelIcon setFrame: CGRectMake(4, headerHeight / 2 - 10, 16, 16)];
    [searchIcon setFrame: CGRectMake(4, headerHeight / 2 - 10, 16, 16)];
    
    UILabel *racesLabel = [[UILabel alloc] initWithFrame: CGRectMake(6, 2, 100, headerHeight - 4)];
    [racesLabel setText: @"Races"];
    [racesLabel setBackgroundColor: [UIColor clearColor]];
    [racesLabel setFont: [UIFont boldSystemFontOfSize: 18.0f]];
    [racesLabel setTextColor: [UIColor darkGrayColor]];
    [header addSubview: racesLabel];
    
    UILabel *clearSearchLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 2, 118, headerHeight - 4)];
    [clearSearchLabel setBackgroundColor: [UIColor colorWithRed:0.3843f green:0.5529 blue:0.7176f alpha:1.0f]];
    [clearSearchLabel setText: @"Clear Search"];
    [clearSearchLabel setTextAlignment: NSTextAlignmentRight];
    [clearSearchLabel setFont: [UIFont systemFontOfSize: 16.0f]];
    [clearSearchLabel setTextColor: [UIColor whiteColor]];
    [clearSearchLabel setUserInteractionEnabled: YES];
    [clearSearchLabel addSubview: cancelIcon];
    [header addSubview: clearSearchLabel];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearSearchParams:)];
    [clearSearchLabel addGestureRecognizer: gesture];
    [gesture release];
    [clearSearchLabel release];
    
    UILabel *searchLabel = [[UILabel alloc] initWithFrame: CGRectMake(192, 2, 124, headerHeight - 4)];
    [searchLabel setBackgroundColor: [UIColor colorWithRed:0.3843f green:0.5529 blue:0.7176f alpha:1.0f]];
    [searchLabel setText: @"Search Races"];
    [searchLabel setTextAlignment: NSTextAlignmentRight];
    [searchLabel setFont: [UIFont systemFontOfSize: 16.0f]];
    [searchLabel setTextColor: [UIColor whiteColor]];
    [searchLabel setUserInteractionEnabled: YES];
    [searchLabel addSubview: searchIcon];
    [header addSubview: searchLabel];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchParams:)];
    [searchLabel addGestureRecognizer: gesture2];
    [gesture2 release];
    [searchLabel release];
    
    //[cancelIcon release];
    //[searchIcon release];
    
    UIView *separator = [[UIView alloc] initWithFrame: CGRectMake(0, headerHeight, 320, 1)];
    [separator setBackgroundColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]];
    [header addSubview: separator];
    
    if(headerSearch == nil)
        headerSearch = [[UISearchBar alloc] init];
    return headerSearch;
    
    //return header;
}*/

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == searchTable){
        if([[UIScreen mainScreen] applicationFrame].size.height > 500){
            if(indexPath.row == 9)
                return 64;
            else if(indexPath.row != 0)
                return 46;
            return 32;
        }else{
            if(indexPath.row == 9)
                return 58;
            else if(indexPath.row != 0)
                return 36;
            return 30;
        }
    }else{
        if(indexPath.section == 0){
            if(indexPath.row == 0)
                return 44;
            else if(showingAdvancedSearch)
                return advancedSearchHeight;
            else if([[UIScreen mainScreen] applicationFrame].size.height > 500)
                return 32;
            else
                return 30;
        }else if(indexPath.section == 1){
            NSDictionary *raceData = [raceList objectAtIndex: indexPath.row];
            
            CGSize reqSize = [[raceData objectForKey:@"name"] sizeWithFont:[UIFont fontWithName:@"Sanchez-Regular" size:20] constrainedToSize:CGSizeMake(296, 100)];
            
            return 78 + reqSize.height;
        }else{
            return 100;
        }
    }
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == searchTable)
        if(showingAdvancedSearch){
            return 9;
        }else{
            return 1;
        }
    else
        if(section == 0)
            return 2;
        else if(section == 1){
            if(raceList != nil){
                return [raceList count];
            }
            return 0;
        }else
            return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == searchTable)
        return 1;
    else
        return 3;
}

- (void)reloadRaces{
    reloading = YES;
    [searchParams setObject:@"1" forKey:@"page"]; // Only reload page 1 if refreshing
    [self retrieveRaceList];
}

- (void)doneLoadingRaces{
    reloading = NO;
    [refreshControl endRefreshing];
    
    [table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
