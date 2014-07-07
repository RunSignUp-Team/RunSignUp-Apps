//
//  RaceSearchViewController.m
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

#import "RaceSearchViewController.h"
#import "RaceListViewController.h"
#import "RaceSearchRoundedTableViewCell.h"

@implementation RaceSearchViewController
@synthesize table;
@synthesize distanceDrop;
@synthesize countryDrop;
@synthesize stateDrop;
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
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        distanceArray = [[NSArray alloc] initWithObjects:@"Distance Units", @"K", @"Miles", @"Yards", @"Meters", nil];
        countryArray = [[NSArray alloc] initWithObjects:@"Country", @"United States", @"Canada", @"France", @"Germany", nil];
        stateArrayUS = [[NSArray alloc] initWithObjects:@"State", @"AK", @"AL", @"AR", @"AZ", @"CA", @"CO", @"CT", @"DE",
                        @"FL", @"GA", @"HA", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME",
                        @"MI", @"MN", @"MO", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM", @"NV", @"NY",
                        @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VA", @"VT", @"WA",
                        @"WI", @"WV", @"WY", nil]; 
        stateArrayCA = [[NSArray alloc] initWithObjects:@"State", @"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"ON", @"PE", @"QC", @"SK", nil];
        stateArrayGE = [[NSArray alloc] initWithObjects:@"State", @"BB", @"BE", @"BW", @"BY", @"HB", @"HE", @"HH", @"MV", @"NI", @"NW", @"RP", @"SH",
                        @"SL", @"SN", @"ST", @"TH", nil];
        
        currentPicker = 0;
        currentSelectedDistance = 0;
        currentSelectedCountry = 1;
        currentSelectedState = 0;
        
        showingBackground = NO;
        
        self.title = @"Search Races";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    // top 34 66 113
    // bottom 72 106 154
    
    UIImage *dropDownStretched = [[UIImage imageNamed:@"DropDown.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *dropDownTapStretched = [[UIImage imageNamed:@"DropDownTap.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    /*[distanceDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [distanceDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [countryDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [countryDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [stateDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [stateDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];*/
    [searchButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [searchButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    for(UITextField *field in @[raceNameField,distanceField,cityField,fromDateField,toDateField]){
        [field setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
    }
    
    for(UIButton *button in @[distanceDrop, stateDrop, countryDrop]){
        [[button titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
    }
    
    dateFieldOriginalTextColor = [[fromDateField textColor] retain];
    
    NSString *countryTitle = [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]];
    [countryDrop setTitle:countryTitle forState:UIControlStateNormal];
    [countryPicker selectRow:currentSelectedCountry inComponent:0 animated:NO];
    
    // MAKE SURE INPUT IS OK
    // Picker view blur beneath in signupviewcontroller
    // picker view solid background in searchviewcont, maybe toolbar to show end
    if([delegate searchParams] != nil){
        if([[delegate searchParams] objectForKey:@"name"])
            [raceNameField setText:[[delegate searchParams] objectForKey:@"name"]];
        if([[delegate searchParams] objectForKey:@"min_distance"])
            [distanceField setText:[[delegate searchParams] objectForKey:@"min_distance"]];
        if([[delegate searchParams] objectForKey:@"start_date"])
            [fromDateField setText: [[delegate searchParams] objectForKey:@"start_date"]];
        if([[delegate searchParams] objectForKey:@"end_date"])
                [toDateField setText: [[delegate searchParams] objectForKey:@"end_date"]];
        if([[delegate searchParams] objectForKey:@"distance_units"]){
            NSString *distanceUnits = [[delegate searchParams] objectForKey:@"distance_units"];
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
        if([[delegate searchParams] objectForKey:@"country_code"]){
            NSString *country = [[delegate searchParams] objectForKey:@"country_code"];
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
            
            if([[delegate searchParams] objectForKey:@"state"] && currentSelectedCountry != 3){
                NSArray *currentStateArray = stateArrayUS;
                if(currentSelectedCountry == 2)
                    currentStateArray = stateArrayCA;
                else if(currentSelectedCountry == 4)
                    currentStateArray = stateArrayGE;
                
                int index = 0;
                for(NSString *state in currentStateArray){
                    if([state isEqualToString:[[delegate searchParams] objectForKey:@"state"]]){
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

- (IBAction)search:(id)sender{
    NSString *name = [raceNameField text];
    NSString *distance = [distanceField text];
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
    if(currentSelectedCountry == 1)
        countryPick = @"US";
    else if(currentSelectedCountry == 2)
        countryPick = @"CA";
    else if(currentSelectedCountry == 3)
        countryPick = @"FR";
    else if(currentSelectedCountry == 4)
        countryPick = @"GE";
    
    NSString *statePick = nil;
    if(currentSelectedCountry != 2 && currentSelectedCountry != 0)
        statePick = [[[stateDrop titleLabel] text] substringFromIndex: 2];
    
    // NOT ENOUGH, ONLY CHECKS IF STARTS WITH A-Z, NOT WHOLE STRING
    // Race name length
    // Distance characters as stated above
    // If distance specified, make sure distance units specified. Not necessarily vice versa
    // 
    
    if([distance length] && [distance doubleValue] == 0){
        [self showAlertFor: @"Invalid distance, please try again."];
        return;
    }else if([distance length] == 0)
        distance = nil;
    
    if([name length] == 0)
        name = nil;
    
    if([fromDate length] == 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        fromDate = [formatter stringFromDate: [NSDate date]];
        [formatter release];
    }
    
    if([toDate length] == 0)
        toDate = nil;
    
    NSMutableDictionary *searchParams = [[NSMutableDictionary alloc] init];
    [searchParams setObject:@"1" forKey:@"page"];
    if(name)[searchParams setObject:name forKey:@"name"];
    if(distance)[searchParams setObject:distance forKey:@"min_distance"];
    if(distancePick)[searchParams setObject:distancePick forKey:@"distance_units"];
    [searchParams setObject:fromDate forKey:@"start_date"];
    if(toDate)[searchParams setObject:toDate forKey:@"end_date"];
    if(countryPick)[searchParams setObject:countryPick forKey:@"country_code"];
    if(statePick)[searchParams setObject:statePick forKey:@"state"];
    
    NSLog(@"%@", searchParams);
    [delegate setSearchParams: searchParams];
    [delegate retrieveRaceList];
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)showAlertFor:(NSString *)reason{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:reason delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    RaceSearchRoundedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[RaceSearchRoundedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setTop: NO];
    [cell setBottom: NO];
    [cell setExtra: NO];
    [cell setMiddleDivider: NO];
    [cell reset];
    
    if(indexPath.row == 0){
        [cell setExtra: YES];
    }else if(indexPath.row == 1){
        if(raceNameField.superview != nil)
            [raceNameField removeFromSuperview];
        [raceNameField setFrame: CGRectMake(36, 0, 248, 64)];
        [cell.contentView addSubview: raceNameField];
        
        [cell setTop: YES];
    }else if(indexPath.row == 2){
        if(distanceField.superview != nil)
            [distanceField removeFromSuperview];
        [distanceField setFrame: CGRectMake(36, 0, 248, 64)];
        [cell.contentView addSubview: distanceField];
    }else if(indexPath.row == 3){
        if(distanceDrop.superview != nil)
            [distanceDrop removeFromSuperview];
        [distanceDrop setFrame: CGRectMake(28, 0, 260, 64)];
        [cell.contentView addSubview: distanceDrop];
    }else if(indexPath.row == 4){
        if(cityField.superview != nil)
            [cityField removeFromSuperview];
        [cityField setFrame: CGRectMake(36, 0, 248, 64)];
        [cell.contentView addSubview: cityField];
    }else if(indexPath.row == 5){
        if(stateDrop.superview != nil)
            [stateDrop removeFromSuperview];
        [stateDrop setFrame: CGRectMake(28, 0, 260, 64)];
        [cell.contentView addSubview: stateDrop];
    }else if(indexPath.row == 6){
        if(countryDrop.superview != nil)
            [countryDrop removeFromSuperview];
        [countryDrop setFrame: CGRectMake(28, 0, 260, 64)];
        [cell.contentView addSubview: countryDrop];
    }else if(indexPath.row == 7){
        if(fromDateField.superview != nil)
            [fromDateField removeFromSuperview];
        if(toDateField.superview != nil)
            [toDateField removeFromSuperview];
        
        [fromDateField setFrame: CGRectMake(20, 0, 140, 64)];
        [toDateField setFrame: CGRectMake(160, 0, 140, 64)];

        [cell.contentView addSubview: fromDateField];
        [cell.contentView addSubview: toDateField];
        
        [cell setMiddleDivider: YES];
        [cell setBottom: YES];
    }else if(indexPath.row == 8){
        if(searchButton.superview != nil)
           [searchButton removeFromSuperview];
        
        [searchButton setFrame: CGRectMake(16, 16, 280, 44)];
        [cell.contentView addSubview: searchButton];
        [cell setExtra: YES];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != 0)
        return 64;
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)hideBackground{
    if(showingBackground){
        [UIView beginAnimations:@"TableSize" context:nil];
        [UIView setAnimationDuration: 0.3f];
        [table setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 260)];
        [UIView commitAnimations];
        showingBackground = NO;
    }
}

- (void)showBackground{
    [fromDateField setTextColor: dateFieldOriginalTextColor];
    [toDateField setTextColor: dateFieldOriginalTextColor];

    if(!showingBackground){
        [UIView beginAnimations:@"TableSize" context:nil];
        [UIView setAnimationDuration: 0.3f];
        [table setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 260)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, 320, 260)];
        [UIView commitAnimations];
        showingBackground = YES;
    }
}

- (IBAction)hidePicker:(id)sender{
    [self hideCurrentPicker: YES];
    [self.view endEditing: YES];
    [self hideBackground];
}

- (void)hideCurrentPicker:(BOOL)animated{
    if(currentPicker != 0){
        UIPickerView *pickerToAnimate = distancePicker;
        UIButton *currentDrop = distanceDrop;
        if(currentPicker == 1){
            pickerToAnimate = distancePicker;
            currentDrop = distanceDrop;
        }else if(currentPicker == 2){
            pickerToAnimate = statePicker;
            currentDrop = stateDrop;
        }else if(currentPicker == 3){
            pickerToAnimate = countryPicker;
            currentDrop = countryDrop;
        }else if(currentPicker == 4 || currentPicker == 5){
            [UIView beginAnimations:@"DatePickerSlide" context:nil];
            [datePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
            [UIView commitAnimations];
            
            currentPicker = 0;
            return;
        }
        
        [currentDrop setSelected: NO];
        
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showBackground];
    
    if(textField == raceNameField){
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else if(textField == distanceField){
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else if(textField == cityField){
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else if(textField == fromDateField || textField == toDateField){
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == distancePicker){
        return [distanceArray objectAtIndex: row];
    }else if(pickerView == countryPicker){
        return [countryArray objectAtIndex: row];
    }else{
        if(currentSelectedCountry == 1)
            return [stateArrayUS objectAtIndex: row];
        else if(currentSelectedCountry == 2)
            return [stateArrayCA objectAtIndex: row];
        else if(currentSelectedCountry == 4)
            return [stateArrayGE objectAtIndex: row];
        else
            return nil;
    }
    return nil;
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
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self showBackground];

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
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self showBackground];

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
    
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self showBackground];

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

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
