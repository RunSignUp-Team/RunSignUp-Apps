//
//  RaceSearchViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSearchViewController.h"
#import "RaceListViewController.h"

@implementation RaceSearchViewController
@synthesize distanceDrop;
@synthesize countryDrop;
@synthesize stateDrop;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize raceNameField;
@synthesize distanceField;
@synthesize fromDateField;
@synthesize toDateField;
@synthesize distancePicker;
@synthesize countryPicker;
@synthesize statePicker;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        distanceArray = [[NSArray alloc] initWithObjects:@"", @"K", @"Miles", @"Yards", @"Meters", nil];
        countryArray = [[NSArray alloc] initWithObjects:@"", @"United States", @"Canada", @"France", @"Germany", nil];
        stateArrayUS = [[NSArray alloc] initWithObjects:@"", @"AK", @"AL", @"AR", @"AZ", @"CA", @"CO", @"CT", @"DE",
                        @"FL", @"GA", @"HA", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME",
                        @"MI", @"MN", @"MO", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM", @"NV", @"NY",
                        @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VA", @"VT", @"WA",
                        @"WI", @"WV", @"WY", nil]; 
        stateArrayCA = [[NSArray alloc] initWithObjects:@"", @"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"ON", @"PE", @"QC", @"SK", nil];
        stateArrayGE = [[NSArray alloc] initWithObjects:@"", @"BB", @"BE", @"BW", @"BY", @"HB", @"HE", @"HH", @"MV", @"NI", @"NW", @"RP", @"SH",
                        @"SL", @"SN", @"ST", @"TH", nil];
        
        currentPicker = 0;
        currentSelectedDistance = 0;
        currentSelectedCountry = 0;
        currentSelectedState = 0;
        
        self.title = @"Search Races";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIExtendedEdgeNone];
    
    // top 34 66 113
    // bottom 72 106 154
    
    UIImage *dropDownStretched = [[UIImage imageNamed:@"DropDown.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *dropDownTapStretched = [[UIImage imageNamed:@"DropDownTap.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [distanceDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [distanceDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [countryDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [countryDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [stateDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [stateDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [searchButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [searchButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    //[UIColor colorWithRed:0.5f green:0.6863f blue:0.8431f alpha:1.0f]

    /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [fromDateField setText: [formatter stringFromDate: [NSDate date]]];
    [formatter release];*/
    
    //// not completed, sleeping
    if([delegate searchParams] != nil){
        if([[delegate searchParams] objectForKey:@"Name"])
            [raceNameField setText:[[delegate searchParams] objectForKey:@"Name"]];
        if([[delegate searchParams] objectForKey:@"Dist"])
            [distanceField setText:[[delegate searchParams] objectForKey:@"Dist"]];
        if([[delegate searchParams] objectForKey:@"FromDate"])
            [fromDateField setText: [[delegate searchParams] objectForKey:@"FromDate"]];
        if([[delegate searchParams] objectForKey:@"ToDate"])
                [toDateField setText: [[delegate searchParams] objectForKey:@"ToDate"]];
        if([[delegate searchParams] objectForKey:@"DistUnits"]){
            int index = 0;
            for(NSString *distanceType in distanceArray){
                if([distanceType isEqualToString:[[delegate searchParams] objectForKey:@"DistUnits"]]){
                    [distanceDrop setTitle:[NSString stringWithFormat:@"  %@", distanceType] forState:UIControlStateNormal];
                    [distancePicker selectRow:index inComponent:0 animated:NO];
                    currentSelectedDistance = index;
                    break;
                }
                index++;
            }
        }
        if([[delegate searchParams] objectForKey:@"Country"]){
            NSString *country = [[delegate searchParams] objectForKey:@"Country"];
            if([country isEqualToString:@"US"])
                currentSelectedCountry = 0;
            else if([country isEqualToString:@"CA"])
                currentSelectedCountry = 1;
            else if([country isEqualToString:@"FR"])
                currentSelectedCountry = 2;
            else
                currentSelectedCountry = 3;
            
            [countryDrop setTitle:[NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]] forState:UIControlStateNormal];
            [countryPicker selectRow:currentSelectedCountry inComponent:0 animated:NO];
            
            if([[delegate searchParams] objectForKey:@"State"] && currentSelectedCountry != 2){
                NSArray *currentStateArray = stateArrayUS;
                if(currentSelectedCountry == 1)
                    currentStateArray = stateArrayCA;
                else if(currentSelectedCountry == 3)
                    currentStateArray = stateArrayGE;
                
                int index = 0;
                for(NSString *state in currentStateArray){
                    if([state isEqualToString:[[delegate searchParams] objectForKey:@"State"]]){
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
    
    [raceNameField becomeFirstResponder];
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
    [searchParams setObject:@"1" forKey:@"Page"];
    if(name)[searchParams setObject:name forKey:@"Name"];
    if(distance)[searchParams setObject:distance forKey:@"Dist"];
    if(distancePick)[searchParams setObject:distancePick forKey:@"DistUnits"];
    [searchParams setObject:fromDate forKey:@"FromDate"];
    if(toDate)[searchParams setObject:toDate forKey:@"ToDate"];
    if(countryPick)[searchParams setObject:countryPick forKey:@"Country"];
    if(statePick)[searchParams setObject:statePick forKey:@"State"];
        
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(currentPicker != 0){
        if(currentPicker == 1){
            [distanceDrop setSelected: NO];
            [UIView beginAnimations:@"PickerSlide" context:nil];
            [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
            [UIView commitAnimations];
        }else if(currentPicker == 2){
            [countryDrop setSelected: NO];
            [UIView beginAnimations:@"PickerSlide" context:nil];
            [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
            [UIView commitAnimations];
        }else{
            [stateDrop setSelected: NO];
            [UIView beginAnimations:@"PickerSlide" context:nil];
            [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
            [UIView commitAnimations];
        }
        currentPicker = 0;
    }
        
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == raceNameField)
        [distanceField becomeFirstResponder];
    else if(textField == distanceField)
        [self showDistancePicker: nil];
    else if(textField == fromDateField)
        [toDateField becomeFirstResponder];
    else if(textField == toDateField)
        [self search: nil];
    
    return NO;
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

- (IBAction)showDistancePicker:(id)sender{
    [self.view endEditing: YES];
    [distanceDrop setSelected: YES];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: NO];
    
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
    
    currentPicker = 1;
}

- (IBAction)showCountryPicker:(id)sender{
    [self.view endEditing: YES];
    [distanceDrop setSelected: NO];
    [countryDrop setSelected: YES];
    [stateDrop setSelected: NO];
    
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    [distancePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    
    currentPicker = 2;
}

- (IBAction)showStatePicker:(id)sender{
    [self.view endEditing: YES];
    [distanceDrop setSelected: NO];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: YES];    
    
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
