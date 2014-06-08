//
//  SignUpViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "RSUModel.h"

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
@synthesize pickerBackgroundView;
@synthesize countryPicker;
@synthesize statePicker;
@synthesize signUpMode;
@synthesize ageHintLabel;
@synthesize navigationBar;
@synthesize userDictionary;
@synthesize rli;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

        self.title = @"Sign Up";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
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
    
    if(signUpMode == RSUSignUpEditingUser){
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        [emailField setHidden: YES];
        self.title = @"Edit Profile";
        for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                CGRect frame = [view frame];
                frame.origin.y -= 117.0f;
                [view setFrame: frame];
            }
        }
        [registerButton setTitle:@"Save Changes" forState:UIControlStateNormal];
        [firstNameField setText: [userDictionary objectForKey:@"first_name"]];
        [lastNameField setText: [userDictionary objectForKey:@"last_name"]];
        [emailField setText: [userDictionary objectForKey:@"email"]];
        [addressField setText: [[userDictionary objectForKey:@"address"] objectForKey:@"street"]];
        [cityField setText: [[userDictionary objectForKey:@"address"] objectForKey:@"city"]];
        
        NSString *countryCode = [[userDictionary objectForKey:@"address"] objectForKey:@"country_code"];
        NSArray *currentStateArray = nil;
        
        if([countryCode isEqualToString: @"US"]){
            currentSelectedCountry = 0;
            currentStateArray = stateArrayUS;
        }else if([countryCode isEqualToString: @"CA"]){
            currentSelectedCountry = 1;
            currentStateArray = stateArrayCA;
        }else if([countryCode isEqualToString: @"FR"]){
            currentSelectedCountry = 2;
        }else{
            currentSelectedCountry = 3;
            currentStateArray = stateArrayGE;
        }
        
        [countryDrop setTitle: [NSString stringWithFormat:@"  %@", [countryArray objectAtIndex: currentSelectedCountry]] forState:UIControlStateNormal];
         
        if(currentSelectedCountry != 2){
            int index = 0;
            for(NSString *state in currentStateArray){
                if([state isEqualToString:[[userDictionary objectForKey:@"address"] objectForKey:@"state"]]){
                    [stateDrop setTitle:[NSString stringWithFormat:@"  %@", state] forState:UIControlStateNormal];
                    [statePicker selectRow:index inComponent:0 animated:NO];
                    currentSelectedState = index;
                    break;
                }
                index++;
            }
        }
        
        [zipcodeField setText: [[userDictionary objectForKey:@"address"] objectForKey:@"zipcode"]];
        [phoneField setText: [userDictionary objectForKey:@"phone"]];
        [dobField setText: [userDictionary objectForKey:@"dob"]];
        if([[userDictionary objectForKey:@"gender"] isEqualToString:@"F"]){
            [genderControl setSelectedSegmentIndex: 1];
        }
    }else if(signUpMode == RSUSignUpNewUser){
        [navigationBar setHidden: NO];
        [scrollView setFrame: CGRectMake(0, 64, scrollView.frame.size.width, scrollView.frame.size.height - 64)];
        [registerButton setTitle:@"Submit" forState:UIControlStateNormal];
    }else if(signUpMode == RSUSignUpSomeoneElse){
        [navigationBar setHidden: NO];
        [scrollView setFrame: CGRectMake(0, 64, scrollView.frame.size.width, scrollView.frame.size.height - 64)];
        [registerButton setTitle:@"Submit" forState:UIControlStateNormal];
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                CGRect frame = [view frame];
                frame.origin.y -= 78.0f;
                [view setFrame: frame];
            }
        }
    }else if(signUpMode == RSUSignUpCreditCardInfo){
        [registerButton setTitle:@"Submit" forState:UIControlStateNormal];
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        [emailField setHidden: YES];
        [zipcodeField setHidden: YES];
        [dobField setHidden: YES];
        [phoneField setHidden: YES];
        [genderControl setHidden: YES];
        self.title = @"Credit Card";
        
        for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                int offset = 117;
                if([view frame].origin.y > [stateDrop frame].origin.y){
                    offset += 170;
                }
                
                CGRect frame = [view frame];
                frame.origin.y -= offset;
                [view setFrame: frame];
            }
        }
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
    
    [[rli label] setText: @"Sending..."];
    [self.view addSubview: rli];
    [rli release];
    
    [scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, MAX(600, registerButton.frame.origin.y + registerButton.frame.size.height))];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSString *genderString = @"M";
    if([genderControl selectedSegmentIndex] == 1)
        genderString = @"F";
    
    for(UIView *view in [scrollView subviews]){
        if([view isKindOfClass: [UITextField class]]){
            if([[(UITextField *)view text] length] == 0){
                if(signUpMode == RSUSignUpEditingUser){
                    if(!(view == emailField || view == passwordField || view == confirmPasswordField)){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields left blank." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if(signUpMode == RSUSignUpSomeoneElse){
                    if(!(view == passwordField || view == confirmPasswordField)){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields left blank." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }
            }
        }
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[firstNameField text] forKey:@"first_name"];
    [dict setObject:[lastNameField text] forKey:@"last_name"];
    [dict setObject:[emailField text] forKey:@"email"];
    [dict setObject:[dobField text] forKey:@"dob"];
    [dict setObject:genderString forKey:@"gender"];
    [dict setObject:[phoneField text] forKey:@"phone"];
    [dict setObject:[passwordField text] forKey:@"password"];
    
    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
    [address setObject:[addressField text] forKey:@"street"];
    [address setObject:[cityField text] forKey:@"city"];
    
    int selectedCountry = [countryPicker selectedRowInComponent: 0];
    if(selectedCountry != 2){
        if(selectedCountry == 0){
            [address setObject:@"US" forKey:@"country_code"];
            [address setObject:[stateArrayUS objectAtIndex: currentSelectedState] forKey:@"state"];
        }else if(selectedCountry == 1){
            [address setObject:@"CA" forKey:@"country_code"];
            [address setObject:[stateArrayCA objectAtIndex: currentSelectedState] forKey:@"state"];
        }else{
            [address setObject:@"US" forKey:@"country_code"];
            [address setObject:[stateArrayGE objectAtIndex: currentSelectedState] forKey:@"state"];
        }
    }else{
        [address setObject:@"FR" forKey:@"country_code"];
    }
    
    [address setObject:[zipcodeField text] forKey:@"zipcode"];
    [dict setObject:address forKey:@"address"];

    [self setUserDictionary: dict];
    
    if(signUpMode == RSUSignUpEditingUser){
        [rli fadeIn];
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUSuccess){
                [delegate didSignUpWithDictionary: userDictionary];
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
    }else if(signUpMode == RSUSignUpSomeoneElse || signUpMode == RSUSignUpNewUser){
        [delegate didSignUpWithDictionary: userDictionary];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(signUpMode == RSUSignUpDefault){
        
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
        if(signUpMode == RSUSignUpEditingUser || signUpMode == RSUSignUpCreditCardInfo)
            [addressField becomeFirstResponder];
        else
            [emailField becomeFirstResponder];
    else if(textField == emailField)
        if(signUpMode == RSUSignUpSomeoneElse)
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
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
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
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
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
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else if(currentPicker == 2){
        [stateDrop setSelected: NO];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height + [donePickerBar frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else{
        [self.view endEditing: YES];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [donePickerBar setFrame: CGRectMake(0, [self.view frame].size.height, 320, 44)];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }
    currentPicker = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
