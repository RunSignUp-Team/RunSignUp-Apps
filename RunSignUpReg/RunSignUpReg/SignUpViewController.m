//
//  SignUpViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "RSUModel.h"
#import "ProfileViewController.h"

@implementation SignUpViewController
@synthesize scrollView;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize addressField;
@synthesize cityField;
@synthesize countryDrop;
@synthesize stateDrop;
@synthesize zipcodeField;
@synthesize dobField;
@synthesize phoneField;
@synthesize genderControl;
@synthesize registerButton;
@synthesize takePhotoButton;
@synthesize chooseExistingButton;
@synthesize profileImageView;
@synthesize donePickerBar;
@synthesize countryPicker;
@synthesize statePicker;
@synthesize isEditingUserProfile;
@synthesize userDictionary;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profileViewController:(ProfileViewController *)pvc{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countryArray = [[NSArray alloc] initWithObjects:@"United States", @"Canada", @"France", @"Germany", nil];
        /*stateArrayUS = [[NSArray alloc] initWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Akansas", @"California", 
                        @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia",@"Hawaii", @"Idaho", @"Illinois",
                        @"Indiana", @"Iowa",@"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland",@"Massachusetts",
                        @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", 
                        @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", 
                        @"Ohio",@"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina",
                        @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
        
        stateArrayCA = [[NSArray alloc] initWithObjects:@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                        @"Newfoundland and Labrador", @"Nova Scotia", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", nil];
        
        stateArrayGE = [[NSArray alloc] initWithObjects:@"Baden-Württemberg", @"Bavaria", @"Berlin",
                        @"Brandenburg", @"Bremen", @"Hamburg", @"Hesse",
                        @"Mecklenburg-Vorpommern", @"Lower Saxony", @"North Rhine-Westphalia", @"Rhineland-Palatinate",
                        @"Saarland", @"Saxony", @"Saxony-Anhalt", @"Schleswig-Holstein", @"Thuringia", nil];
        */
        
        stateArrayUS = [[NSArray alloc] initWithObjects:@"AK", @"AL", @"AR", @"AZ", @"CA", @"CO", @"CT", @"DE",
                        @"FL", @"GA", @"HA", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME",
                        @"MI", @"MN", @"MO", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM", @"NV", @"NY",
                        @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VA", @"VT", @"WA",
                        @"WI", @"WV", @"WY", nil]; 
        stateArrayCA = [[NSArray alloc] initWithObjects:@"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"ON", @"PE", @"QC", @"SK", nil];
        stateArrayGE = [[NSArray alloc] initWithObjects:@"BB", @"BE", @"BW", @"BY", @"HB", @"HE", @"HH", @"MV", @"NI", @"NW", @"RP", @"SH",
                        @"SL", @"SN", @"ST", @"TH", nil];
        
        currentPicker = 0;
        currentSelectedCountry = 0;
        currentSelectedState = 0;

        profileViewController = pvc;
        self.title = @"Sign Up";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    [scrollView setContentSize: CGSizeMake(320, 820)];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *dropDownStretched = [[UIImage imageNamed:@"DropDown.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    UIImage *dropDownTapStretched = [[UIImage imageNamed:@"DropDownTap.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:0];
    
    [countryDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [countryDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [stateDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [stateDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    
    [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height + 2*[donePickerBar frame].size.height, 320, 216)];
    [statePicker setFrame: CGRectMake(0, [self.view frame].size.height + 2*[donePickerBar frame].size.height, 320, 216)];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    [registerButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [registerButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [takePhotoButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [takePhotoButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [chooseExistingButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [chooseExistingButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    if(isEditingUserProfile){
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        [emailField setHidden: YES];
        for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                CGRect frame = [view frame];
                frame.origin.y -= 117.0f;
                [view setFrame: frame];
            }
        }
        [registerButton setTitle:@"Save Changes" forState:UIControlStateNormal];
        [firstNameField setText: [userDictionary objectForKey:@"FName"]];
        [lastNameField setText: [userDictionary objectForKey:@"LName"]];
        [emailField setText: [userDictionary objectForKey:@"Email"]];
        [addressField setText: [userDictionary objectForKey:@"Street"]];
        [cityField setText: [userDictionary objectForKey:@"City"]];
        [countryDrop setTitle: [NSString stringWithFormat:@"  %@", [userDictionary objectForKey:@"Country"]] forState:UIControlStateNormal];
        [stateDrop setTitle: [NSString stringWithFormat:@"  %@", [userDictionary objectForKey:@"State"]] forState:UIControlStateNormal];
        [zipcodeField setText: [userDictionary objectForKey:@"Zipcode"]];
        [phoneField setText: [userDictionary objectForKey:@"Phone"]];
        [dobField setText: [userDictionary objectForKey:@"DOB"]];
        if([[userDictionary objectForKey:@"Gender"] isEqualToString:@"F"]){
            [genderControl setSelectedSegmentIndex: 1];
        }
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
    
    [[rli label] setText: @"Sending..."];
    [self.view addSubview: rli];
    [rli release];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == countryPicker)
        return [countryArray objectAtIndex: row];
    else
        if(currentSelectedCountry == 0)
            return [stateArrayUS objectAtIndex: row];
        else if(currentSelectedCountry == 1)
            return [stateArrayCA objectAtIndex: row];
        else if(currentSelectedCountry == 3)
            return [stateArrayGE objectAtIndex: row];
        else
            return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == countryPicker)
        return 4;
    else{
        if(currentSelectedCountry == 0)
            return [stateArrayUS count];
        else if(currentSelectedCountry == 1)
            return [stateArrayCA count];
        else if(currentSelectedCountry == 3)
            return [stateArrayGE count];
        else
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == countryPicker){
        if(row != currentSelectedCountry){
            currentSelectedCountry = row;
            currentSelectedState = 0;
            [statePicker reloadAllComponents];
            
            [countryDrop setTitle:[NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: row]] forState:UIControlStateNormal];
            if(currentSelectedCountry == 0)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayUS objectAtIndex: 0]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 1)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayCA objectAtIndex: 0]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 2)
                [stateDrop setTitle:@"" forState:UIControlStateNormal];
            else if(currentSelectedCountry == 3)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: 0]] forState:UIControlStateNormal];
        }
    }else{
        if(row != currentSelectedState){
            currentSelectedState = row;
            if(currentSelectedCountry == 0)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayUS objectAtIndex: row]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 1)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayCA objectAtIndex: row]] forState:UIControlStateNormal];
            else if(currentSelectedCountry == 3)
                [stateDrop setTitle:[NSString stringWithFormat:@"  %@", [stateArrayGE objectAtIndex: row]] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)saveProfile:(id)sender{
    if(isEditingUserProfile){
        [rli fadeIn];
        
        NSString *genderString = @"M";
        if([genderControl selectedSegmentIndex] == 1)
            genderString = @"F";
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[firstNameField text] forKey:@"FName"];
        [dict setObject:[lastNameField text] forKey:@"LName"];
        [dict setObject:[emailField text] forKey:@"Email"];
        [dict setObject:[dobField text] forKey:@"DOB"];
        [dict setObject:genderString forKey:@"Gender"];
        [dict setObject:[phoneField text] forKey:@"Phone"];
        [dict setObject:[addressField text] forKey:@"Street"];
        [dict setObject:[cityField text] forKey:@"City"];
        int selectedCountry = [countryPicker selectedRowInComponent: 0];
        if(selectedCountry != 2){
            if(selectedCountry == 0){
                [dict setObject:@"US" forKey:@"Country"];
                [dict setObject:[stateArrayUS objectAtIndex: [statePicker selectedRowInComponent:0]] forKey:@"State"];
            }else if(selectedCountry == 1){
                [dict setObject:@"CA" forKey:@"Country"];
                [dict setObject:[stateArrayCA objectAtIndex: [statePicker selectedRowInComponent:0]] forKey:@"State"];
            }else{
                [dict setObject:@"US" forKey:@"Country"];
                [dict setObject:[stateArrayGE objectAtIndex: [statePicker selectedRowInComponent:0]] forKey:@"State"];
            }
        }else{
            [dict setObject:@"FR" forKey:@"Country"];
        }
        
        [dict setObject:[zipcodeField text] forKey:@"Zipcode"];
        [self setUserDictionary: dict];
        
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUSuccess){
                [profileViewController setUserDictionary: userDictionary];
                [profileViewController updateDataWithUserDictionary];
                [self.navigationController popViewControllerAnimated: YES];
            }else if(didSucceed == RSUInvalidData){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid data, please revise your information and try again." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else if(didSucceed == RSUNoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [rli fadeOut];
        };
        [[RSUModel sharedModel] editUserWithInfo:dict response:response];
    }else{
        // create user
    }
}

- (IBAction)takePhoto:(id)sender{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate: self];
        [picker setSourceType: UIImagePickerControllerSourceTypeCamera];
        [picker setAllowsEditing: YES];
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
}

- (IBAction)chooseExistingPhoto:(id)sender{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate: self];
        [picker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setAllowsEditing: YES];
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = [info objectForKey: UIImagePickerControllerEditedImage];
    [profileImageView setImage: chosenImage];
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(currentPicker != 0)
        [self hideCurrentInput: nil];

    [UIView beginAnimations:@"KeyboardSlide" context:nil];
    [UIView setAnimationDuration: 0.25f];
    [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height - 216 - [donePickerBar frame].size.height, 320, 44)];
    [UIView commitAnimations];
    
    float scrollToLocation = [textField frame].origin.y - 78;
    if(scrollToLocation < 0)
        scrollToLocation = 0;
    
    [scrollView setContentOffset:CGPointMake(0, scrollToLocation) animated:YES];
   
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == firstNameField)
        [lastNameField becomeFirstResponder];
    else if(textField == lastNameField)
        [emailField becomeFirstResponder];
    else if(textField == emailField)
        if(isEditingUserProfile)
            [addressField becomeFirstResponder];
        else
            [passwordField becomeFirstResponder];
    else if(textField == passwordField)
        [confirmPasswordField becomeFirstResponder];
    else if(textField == confirmPasswordField)
        [addressField becomeFirstResponder];
    else if(textField == addressField)
        [cityField becomeFirstResponder];
    else if(textField == cityField){
        [self showCountryPicker: nil];
    }else if(textField == zipcodeField)
        [dobField becomeFirstResponder];
    else if(textField == dobField)
        [phoneField becomeFirstResponder];
    else if(textField == phoneField)
        [self hideCurrentInput: nil];
    
    return NO;
}

- (IBAction)showCountryPicker:(id)sender{
    [self.view endEditing: YES];
    [countryDrop setSelected: YES];
    [stateDrop setSelected: NO];
    if(currentPicker == 0){
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height - 216 - [donePickerBar frame].size.height, 320, 44)];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
    }
    
    float scrollToLocation = [countryDrop frame].origin.y - 78;
    if(scrollToLocation < 0)
        scrollToLocation = 0;
    
    [scrollView setContentOffset:CGPointMake(0, scrollToLocation) animated:YES];
    currentPicker = 1;
}

- (IBAction)showStatePicker:(id)sender{
    [self.view endEditing: YES];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: YES];    
    if(currentPicker == 0){
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height - 216 - [donePickerBar frame].size.height, 320, 44)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    
    float scrollToLocation = [stateDrop frame].origin.y - 78;
    if(scrollToLocation < 0)
        scrollToLocation = 0;
    
    [scrollView setContentOffset:CGPointMake(0, scrollToLocation) animated:YES];
    
    currentPicker = 2;
}

- (IBAction)hideCurrentInput:(id)sender{    
    if(currentPicker == 1){
        [countryDrop setSelected: NO];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else if(currentPicker == 2){
        [stateDrop setSelected: NO];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else{
        [self.view endEditing: YES];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [UIView commitAnimations];
    }
    currentPicker = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
