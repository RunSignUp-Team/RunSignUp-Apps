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
#import "RaceSearchViewController.h"
#import "RaceDetailsViewController.h"
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
@synthesize raceNameField;
@synthesize distanceField;
@synthesize fromDateField;
@synthesize toDateField;
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
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:80];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching List..."];
        
        [self.view addSubview: rli];
        [rli release];
        
        currentPicker = 0;
        currentSelectedDistance = 0;
        currentSelectedCountry = 1;
        currentSelectedState = 0;
        
        showingBackground = NO;
        showingAdvancedSearch = NO;
        
        if([[UIScreen mainScreen] applicationFrame].size.height > 500)
            advancedSearchHeight = 460;
        else
            advancedSearchHeight = 374;
        
        searchActive = NO;
        self.currentSearch = nil;
        
        self.searchParams = nil;
        moreResultsToRetrieve = YES;
        
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0, 0 - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        [refreshHeaderView setDelegate: self];
        
        [self.table addSubview: refreshHeaderView];
        [refreshHeaderView release];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        [prevNextControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:16]} forState:UIControlStateNormal];
    }else{
        [prevNextControl setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"OpenSans" size:16]} forState:UIControlStateNormal];
    }
    
    distanceArray = [[NSArray alloc] initWithObjects:@"Distance Units", @"Kilometers", @"Miles", @"Yards", @"Meters", nil];
    countryArray = [[NSArray alloc] initWithObjects:@"Country", @"United States", @"Canada", @"France", @"Germany", nil];
    stateArrayUS = [[NSArray alloc] initWithObjects:@"State", @"AK", @"AL", @"AR", @"AZ", @"CA", @"CO", @"CT", @"DE",
                    @"FL", @"GA", @"HA", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME",
                    @"MI", @"MN", @"MO", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM", @"NV", @"NY",
                    @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VA", @"VT", @"WA",
                    @"WI", @"WV", @"WY", nil];
    stateArrayCA = [[NSArray alloc] initWithObjects:@"State", @"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"ON", @"PE", @"QC", @"SK", nil];
    stateArrayGE = [[NSArray alloc] initWithObjects:@"State", @"BB", @"BE", @"BW", @"BY", @"HB", @"HE", @"HH", @"MV", @"NI", @"NW", @"RP", @"SH",
                    @"SL", @"SN", @"ST", @"TH", nil];
    
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
    [dateClearButton setEnabled: NO];
    [dateClearButton setWidth: 0.01f]; // dirty way of hiding the button
    
    NSString *countryTitle = [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]];
    [countryDrop setTitle:countryTitle forState:UIControlStateNormal];
    [countryPicker selectRow:currentSelectedCountry inComponent:0 animated:NO];
    
    // Get ready to place search table into headerview
    [searchTable removeFromSuperview];
    
    //[table setContentOffset: CGPointMake(0, 44) animated:YES];
    [self retrieveRaceList];
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
                        [statePicker selectRow:index inComponent:0 animated:NO];
                        currentSelectedState = index;
                        break;
                    }
                    index++;
                }
            }else{
                [stateDrop setTitle:@"" forState:UIControlStateNormal];
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
    
    if([fromDate length] == 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        fromDate = [formatter stringFromDate: [NSDate date]];
        [formatter release];
    }
    
    if([toDate length] == 0)
        toDate = nil;
    
    NSMutableDictionary *newSearchParams = [[NSMutableDictionary alloc] init];
    [newSearchParams setObject:@"1" forKey:@"page"];
    if(name)[newSearchParams setObject:name forKey:@"name"];
    if(distance)[newSearchParams setObject:distance forKey:@"min_distance"];
    if(distancePick)[newSearchParams setObject:distancePick forKey:@"distance_units"];
    if(city)[newSearchParams setObject:city forKey:@"city"];
    [newSearchParams setObject:fromDate forKey:@"start_date"];
    if(toDate)[newSearchParams setObject:toDate forKey:@"end_date"];
    if(countryPick)[newSearchParams setObject:countryPick forKey:@"country_code"];
    if(statePick)[newSearchParams setObject:statePick forKey:@"state"];
    
    NSLog(@"%@", newSearchParams);
    
    if(showingAdvancedSearch)
        [self toggleAdvancedSearch: nil];
    [self hideBackground];
    [self setSearchParams: newSearchParams];
    
    searchActive = NO;
    self.currentSearch = nil;
    
    [self retrieveRaceList];
}

- (void)retrieveRaceList{
    [rli fadeIn];
    void (^response)(NSArray *) = ^(NSArray *list){
        moreResultsToRetrieve = YES;
        if(list == nil || [list count] < 10)
            moreResultsToRetrieve = NO;
        
        NSLog(@"Search active: %@", @(searchActive));
        
        self.raceList = list;
        [rli fadeOut];
        
        [table reloadData];
        //[table setContentOffset: CGPointMake(0, 44) animated:YES];
        [self doneLoadingTableViewData:YES];
    };
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (void)retrieveRaceListAndAppend{
    [rli fadeIn];
    void (^response)(NSArray *) = ^(NSArray *list){
        if(list == nil || [list count] == 0){
            // Page retrieval returned empty - reset page number
            moreResultsToRetrieve = NO;
            int currentPage = [[searchParams objectForKey:@"page"] intValue];
            [searchParams setObject:[NSString stringWithFormat:@"%i", MAX(currentPage - 1, 0)] forKey:@"page"];
        }else if([list count] < 10)
            moreResultsToRetrieve = NO;
        
        int oldCount = [raceList count];
        NSMutableArray *newRaceList = [[NSMutableArray alloc] initWithArray:raceList];
        [newRaceList addObjectsFromArray: list];
        self.raceList = newRaceList;
        [rli fadeOut];
        searchActive = NO;
        self.currentSearch = nil;
        [table reloadData];
        //[table setContentOffset: CGPointMake(0, 44) animated:YES];
        
        if([raceList count] != oldCount){
            UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldCount inSection:0]];
            [cell setAlpha: 0.0f];
            [UIView beginAnimations:@"Cell Fade" context:nil];
            [UIView setAnimationDuration: 0.75f];
            [cell setAlpha: 1.0f];
            [UIView commitAnimations];
        }
            
        [self doneLoadingTableViewData:NO];
    };
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (void)searchFieldDidBeginEdit{
    if(showingAdvancedSearch)
        [self toggleAdvancedSearch: nil];
    
    searchActive = YES;
    self.currentSearch = nil;
    NSLog(@"Search active: YES");
}

- (void)searchFieldDidEditText:(NSString *)text{
    searchActive = YES;
    self.currentSearch = [NSString stringWithString: text];
    
    NSLog(@"Current search: %@", currentSearch);
}

- (void)searchFieldDidCancel{
    searchActive = NO;
    self.currentSearch = nil;
    NSLog(@"Search active: NO");
}

- (void)searchButtonTappedWithSearch:(NSString *)search{
    self.searchParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:search, @"name", nil];
    searchActive = NO;
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
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
            [UIView commitAnimations];
            
            currentPicker = 0;
            return;
        }
        
        [currentDrop setSelected: NO];
        [currentDropTriangle setHighlighted: NO];
        
        if(animated)
            [UIView beginAnimations:@"PickerSlide" context:nil];
        [pickerToAnimate setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        if(animated)
            [UIView commitAnimations];
        
        currentPicker = 0;
    }
}

- (void)showDatePickerForFromDateField:(BOOL)from{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [self showBackground];
    
    [self scrollTableToSearchTableRow: [NSIndexPath indexPathForRow:7 inSection:0]];

    [dateClearButton setEnabled: YES];
    [dateClearButton setWidth: 0.0f];
    
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
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        }else{
            [self.view endEditing: YES];
            [UIView beginAnimations:@"DatePickerSlide" context:nil];
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
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
            rowText = [stateArrayUS objectAtIndex: row];
        else if(currentSelectedCountry == 2)
            rowText = [stateArrayCA objectAtIndex: row];
        else if(currentSelectedCountry == 4)
            rowText = [stateArrayGE objectAtIndex: row];
    }
    
    if(view == nil){
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 312, 22)];
        [label setTextAlignment: NSTextAlignmentCenter];
        [label setFont: [UIFont fontWithName:@"OpenSans" size:18]];
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
        if(row != currentSelectedDistance){
            currentSelectedDistance = row;
            [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", [distanceArray objectAtIndex: row]] forState:UIControlStateNormal];
        }
    }else if(pickerView == countryPicker){
        if(row != currentSelectedCountry){
            currentSelectedCountry = row;
            currentSelectedState = 0;
            [statePicker reloadAllComponents];
            
            if(currentSelectedCountry != 0 && currentSelectedCountry != 3)
                [statePicker setUserInteractionEnabled: YES];
            else
                [statePicker setUserInteractionEnabled: NO];
            
            [countryDrop setTitle:[NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: row]] forState:UIControlStateNormal];
            if(currentSelectedCountry == 0)
                [stateDrop setTitle:@"  " forState:UIControlStateNormal];
            else if(currentSelectedCountry == 1)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayUS objectAtIndex: 0]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 2)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayCA objectAtIndex: 0]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 3)
                [stateDrop setTitle:@"  " forState:UIControlStateNormal];
            else if(currentSelectedCountry == 4)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: 0]] forState:UIControlStateNormal];
        }
    }else{
        if(row != currentSelectedState){
            currentSelectedState = row;
            if(currentSelectedCountry == 1)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayUS objectAtIndex: row]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 2)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayCA objectAtIndex: row]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 4)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: row]] forState:UIControlStateNormal];
        }
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
    }else{
        [toggleSearchButton setTitle:@"Show Advanced Search" forState:UIControlStateNormal];
        [self hidePicker: nil];
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
        [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
        
    }else{
        [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    
    currentPicker = 1;
}

- (IBAction)showStatePicker:(id)sender{
    [self.view endEditing: YES];
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
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
        
    }else{
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    
    currentPicker = 2;
}

- (IBAction)showCountryPicker:(id)sender{
    [self.view endEditing: YES];
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
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, 320, 260)];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
        
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    
    currentPicker = 3;
}

- (void)hideBackground{
    if(showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 260)];
        [UIView commitAnimations];
        showingBackground = NO;
    }
}

- (void)showBackground{
    [fromDateField setTextColor: dateFieldOriginalTextColor];
    [toDateField setTextColor: dateFieldOriginalTextColor];
    
    [dateClearButton setEnabled: NO];
    [dateClearButton setWidth: 0.01f];
    
    if(!showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, 320, 260)];
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
        
        [cell setTop: NO];
        [cell setBottom: NO];
        [cell setExtra: NO];
        [cell setMiddleDivider: NO];
        [cell reset];
        [cell setCellHeight: cellHeight];
        
        if(indexPath.row == 0){
            if(toggleSearchButton.superview != nil)
                [toggleSearchButton removeFromSuperview];
            [toggleSearchButton setFrame: CGRectMake(20, 0, 280, cellHeight)];
            [cell.contentView addSubview: toggleSearchButton];
            [cell setExtra: YES];
        }else if(indexPath.row == 1){
            if(raceNameField.superview != nil)
                [raceNameField removeFromSuperview];
            [raceNameField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: raceNameField];
            [cell setTop: YES];
        }else if(indexPath.row == 2){
            if(distanceField.superview != nil)
                [distanceField removeFromSuperview];
            [distanceField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: distanceField];
        }else if(indexPath.row == 3){
            if(distanceDrop.superview != nil)
                [distanceDrop removeFromSuperview];
            if(distanceDropTriangle.superview != nil)
                [distanceDropTriangle removeFromSuperview];
            
            [distanceDrop setFrame: CGRectMake(28, 0, 260, cellHeight)];
            [distanceDropTriangle setFrame: CGRectMake(255, cellHeight / 2 - distanceDropTriangle.frame.size.height / 2, distanceDropTriangle.frame.size.width, distanceDropTriangle.frame.size.height)];
            [cell.contentView addSubview: distanceDrop];
            [cell.contentView addSubview: distanceDropTriangle];
        }else if(indexPath.row == 4){
            if(cityField.superview != nil)
                [cityField removeFromSuperview];
            [cityField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: cityField];
        }else if(indexPath.row == 5){
            if(stateDrop.superview != nil)
                [stateDrop removeFromSuperview];
            if(stateDropTriangle.superview != nil)
                [stateDropTriangle removeFromSuperview];
            [stateDrop setFrame: CGRectMake(28, 0, 260, cellHeight)];
            [stateDropTriangle setFrame: CGRectMake(255, cellHeight / 2 - stateDropTriangle.frame.size.height / 2, stateDropTriangle.frame.size.width, stateDropTriangle.frame.size.height)];

            [cell.contentView addSubview: stateDrop];
            [cell.contentView addSubview: stateDropTriangle];
        }else if(indexPath.row == 6){
            if(countryDrop.superview != nil)
                [countryDrop removeFromSuperview];
            if(countryDropTriangle.superview != nil)
                [countryDropTriangle removeFromSuperview];
            
            [countryDrop setFrame: CGRectMake(28, 0, 260, cellHeight)];
            [countryDropTriangle setFrame: CGRectMake(255, cellHeight / 2 - countryDropTriangle.frame.size.height / 2, countryDropTriangle.frame.size.width, countryDropTriangle.frame.size.height)];

            [cell.contentView addSubview: countryDrop];
            [cell.contentView addSubview: countryDropTriangle];
        }else if(indexPath.row == 7){
            if(fromDateField.superview != nil)
                [fromDateField removeFromSuperview];
            if(toDateField.superview != nil)
                [toDateField removeFromSuperview];
            
            [fromDateField setFrame: CGRectMake(20, 0, 140, cellHeight)];
            [toDateField setFrame: CGRectMake(160, 0, 140, cellHeight)];
            
            [cell.contentView addSubview: fromDateField];
            [cell.contentView addSubview: toDateField];
            
            [cell setMiddleDivider: YES];
            [cell setBottom: YES];
        }else if(indexPath.row == 8){
            if(searchButton.superview != nil)
                [searchButton removeFromSuperview];
            
            [searchButton setFrame: CGRectMake(20, cellHeight / 2 - 22, 280, 44)];
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
                
                if(searchActive){
                    NSLog(@"Loading search active");
                    [cell layoutActive: YES];
                    
                    // Delay becomeFirstResponder because otherwise the message gets lost
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [[cell searchField] setText: currentSearch];
                        [[cell searchField] becomeFirstResponder];
                    });
                }else{
                    NSLog(@"Loading search inactive");
                    [cell layoutActive: NO];
                }
                    
                return cell;
            }else{
                static NSString *SearchTableCellIdentifier = @"SearchTableCellIdentifier";
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTableCellIdentifier];
                if(cell == nil){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchTableCellIdentifier];
                }
                
                if(searchTable.superview != nil)
                    [searchTable removeFromSuperview];
                
                [cell.contentView addSubview: searchTable];
                
                return cell;
            }
        }else if(indexPath.section == 1){
            static NSString *RaceCellIdentifier = @"RaceCellIdentifier";

            RaceTableViewCell *cell = (RaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RaceCellIdentifier];
            if(cell == nil){
                cell = [[RaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RaceCellIdentifier];
            }
            
            [cell setData: [raceList objectAtIndex: indexPath.row]];
            
            if(indexPath.row % 2)
                [[cell contentView] setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
            else
                [[cell contentView] setBackgroundColor: [UIColor whiteColor]];
            
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
            
            if(moreResultsToRetrieve){
                [[cell textLabel] setText:@"Load More..."];
                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
            }else{
                [[cell textLabel] setText:@"All Results Loaded"];
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            }
            
            [[cell textLabel] setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
            [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:18]];
            [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
            
            if([raceList count] % 2){
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
        RaceDetailsViewController *rdvc = [[RaceDetailsViewController alloc] initWithNibName:@"RaceDetailsViewController" bundle:nil data:[raceList objectAtIndex: indexPath.row]];
        [self.navigationController pushViewController:rdvc animated:YES];
        [rdvc release];
    }else if(indexPath.section == 2 && moreResultsToRetrieve){
        if([searchParams objectForKey:@"page"]){
            int currentPage = [[searchParams objectForKey:@"page"] intValue];
            [searchParams setObject:[NSString stringWithFormat:@"%i", currentPage + 1] forKey:@"page"];
        }else if(searchParams){
            [searchParams setObject:@"2" forKey:@"page"];
            // No page value was listed, assumed to be 1. Increment to 2^
        }else{
            searchParams = [[NSMutableDictionary alloc] init];
            [searchParams setObject:@"2" forKey:@"page"];
        }
        [self retrieveRaceListAndAppend];
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
            if(indexPath.row == 8)
                return 64;
            else if(indexPath.row != 0)
                return 52;
            return 32;
        }else{
            if(indexPath.row == 8)
                return 64;
            else if(indexPath.row != 0)
                return 40;
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
            NSDictionary *data = [raceList objectAtIndex: indexPath.row];
            CGSize reqSize = [[data objectForKey:@"name"] sizeWithFont:[UIFont fontWithName:@"Sanchez-Regular" size:20] constrainedToSize:CGSizeMake(296, 100)];
            
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
        else if(section == 1)
            return [raceList count];
        else
            return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == searchTable)
        return 1;
    else
        return 3;
}

- (void)reloadTableViewDataSource{
    reloading = YES;
    [searchParams setObject:@"1" forKey:@"page"]; // Only reload page 1 if refreshing
    [self retrieveRaceList];
}

- (void)doneLoadingTableViewData:(BOOL)scroll{
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    if(scroll)
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
