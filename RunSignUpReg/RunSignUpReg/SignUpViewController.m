//
//  SignUpViewController.m
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

#import "SignUpViewController.h"
#import "RSUModel.h"
#import "RoundedTableViewCell.h"

@implementation SignUpViewController
@synthesize table;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize addressField;
@synthesize cityField;
@synthesize countryDrop;
@synthesize stateDrop;
@synthesize countryDropTriangle;
@synthesize stateDropTriangle;
@synthesize zipcodeField;
@synthesize dobField;
@synthesize phoneField;
@synthesize genderControl;
@synthesize genderUnderline;
@synthesize registerButton;
@synthesize takePhotoButton;
@synthesize chooseExistingButton;
@synthesize profileImageView;
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
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        
        [[rli label] setText: @"Sending..."];

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
    
    [self.view addSubview: rli];
    [rli release];
    
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
    
    /*[countryDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [countryDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];
    [stateDrop setBackgroundImage:dropDownStretched forState:UIControlStateNormal];
    [stateDrop setBackgroundImage:dropDownTapStretched forState:UIControlStateSelected];*/
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    [registerButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    //[registerButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [takePhotoButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    //[takePhotoButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [chooseExistingButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    //[chooseExistingButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [[registerButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:18]];
    
    [genderControl setDividerImage:[UIImage imageNamed:@"GenderControlDivider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [genderControl setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [genderControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Sanchez-Regular" size:18]} forState:UIControlStateNormal];
    [genderControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"Sanchez-Regular" size:18]} forState:UIControlStateSelected];

    for(UITextField *field in @[firstNameField, lastNameField, emailField, passwordField, confirmPasswordField, addressField, cityField, zipcodeField, dobField, phoneField]){
        [field setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
        [field setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
    }
    
    for(UIButton *button in @[stateDrop, countryDrop]){
        [[button titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:16]];
        [button setTitleColor:[UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f] forState:UIControlStateNormal];
    }
    
    if(signUpMode == RSUSignUpEditingUser){
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        [emailField setHidden: YES];
        self.title = @"Edit Profile";
        /*for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                CGRect frame = [view frame];
                frame.origin.y -= 117.0f;
                [view setFrame: frame];
            }
        }*/
        [registerButton setTitle:@"SAVE CHANGES" forState:UIControlStateNormal];
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
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [self.navigationItem setLeftBarButtonItem: cancelButton];
        [cancelButton release];
        
        self.title = @"New User";

        [registerButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    }else if(signUpMode == RSUSignUpSomeoneElse){
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [self.navigationItem setLeftBarButtonItem: cancelButton];
        [cancelButton release];
        
        self.title = @"Create User";

        [registerButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        /*for(UIView *view in [scrollView subviews]){
            if([view frame].origin.y > [confirmPasswordField frame].origin.y){
                CGRect frame = [view frame];
                frame.origin.y -= 78.0f;
                [view setFrame: frame];
            }
        }*/
    }/*else if(signUpMode == RSUSignUpCreditCardInfo){
        [registerButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
        [passwordField setHidden: YES];
        [confirmPasswordField setHidden: YES];
        [emailField setHidden: YES];
        [zipcodeField setHidden: YES];
        [dobField setHidden: YES];
        [phoneField setHidden: YES];
        [genderControl setHidden: YES];
        self.title = @"Credit Card";
        
        /*for(UIView *view in [scrollView subviews]){
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
    }*/

    //[scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, MAX(600, registerButton.frame.origin.y + registerButton.frame.size.height))];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)cancel:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *rowText = nil;
    
    if(pickerView == countryPicker)
        rowText = [countryArray objectAtIndex: row];
    else
        if(currentSelectedCountry == 0)
            rowText = [stateArrayUS objectAtIndex: row];
        else if(currentSelectedCountry == 1)
            rowText = [stateArrayCA objectAtIndex: row];
        else if(currentSelectedCountry == 3)
            rowText = [stateArrayGE objectAtIndex: row];
    
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
    
    /*for(UIView *view in [scrollView subviews]){
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
    }*/
    
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
    
    if([dict objectForKey: @"first_name"] == nil || [dict objectForKey: @"last_name"] == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name field is missing, please revise and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([dict objectForKey: @"email"] == nil || [[dict objectForKey: @"email"] rangeOfString:@"@"].location == NSNotFound){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([dict objectForKey: @"dob"] == nil || [[RSUModel convertSlashDateToDashDate: [RSUModel standardizeDate: [dict objectForKey:@"dob"]]] isEqualToString: @"Error"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid date of birth and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([dict objectForKey: @"gender"] == nil || !([[dict objectForKey: @"gender"] isEqualToString: @"M"] || [[dict objectForKey: @"gender"] isEqualToString: @"F"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please choose a gender and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([dict objectForKey: @"phone"] == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid phone number and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(signUpMode == RSUSignUpNewUser && [dict objectForKey: @"password"] == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid password and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(signUpMode == RSUSignUpNewUser && ![[passwordField text] isEqualToString: [confirmPasswordField text]]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a matching passwords and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
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
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
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

- (void)scrollToTableRow:(int)row{
    NSLog(@"Scrolling to table row: %i", row);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        float offset = MAX(row * 52 - 100, 0);
        [table setContentOffset: CGPointMake(0, offset) animated:YES];
    });
    
}

- (void)hideBackground{
    if(showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height, 320, 260)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"TableSize" context:nil];
        [table setFrame: CGRectMake(0, 0, 320, [self.view frame].size.height)];
        [UIView commitAnimations];
        
        showingBackground = NO;
    }
}

- (void)showBackground{
    if(!showingBackground){
        [UIView beginAnimations:@"BackgroundSlide" context:nil];
        [pickerBackgroundView setFrame: CGRectMake(0, [self.view frame].size.height - 260, 320, 260)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"TableSize" context:nil];
        [table setFrame: CGRectMake(0, 0, 320, [self.view frame].size.height - 260)];
        [UIView commitAnimations];
        
        showingBackground = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(currentPicker != 0)
        [self hideCurrentInput: nil];

    currentInput = textField;
    [self showBackground];

    if(textField == firstNameField){
        [self scrollToTableRow: SignUpCellFirstName];
    }else if(textField == lastNameField){
        [self scrollToTableRow: SignUpCellLastName];
    }else if(textField == emailField){
        [self scrollToTableRow: SignUpCellEmail];
    }else if(textField == passwordField){
        [self scrollToTableRow: SignUpCellPass];
    }else if(textField == confirmPasswordField){
        [self scrollToTableRow: SignUpCellConfirmPass];
    }else if(textField == addressField){
        if(signUpMode == RSUSignUpEditingUser)
            [self scrollToTableRow: SignUpCellAddress - 3];
        else if(signUpMode == RSUSignUpNewUser)
            [self scrollToTableRow: SignUpCellAddress];
        else
            [self scrollToTableRow: SignUpCellAddress - 2];
    }else if(textField == cityField){
        if(signUpMode == RSUSignUpEditingUser)
            [self scrollToTableRow: SignUpCellCity - 3];
        else if(signUpMode == RSUSignUpNewUser)
            [self scrollToTableRow: SignUpCellCity];
        else
            [self scrollToTableRow: SignUpCellCity - 2];
    }else if(textField == zipcodeField){
        if(signUpMode == RSUSignUpEditingUser)
            [self scrollToTableRow: SignUpCellZip - 3];
        else if(signUpMode == RSUSignUpNewUser)
            [self scrollToTableRow: SignUpCellZip];
        else
            [self scrollToTableRow: SignUpCellZip - 2];
    }else if(textField == dobField){
        if(signUpMode == RSUSignUpEditingUser)
            [self scrollToTableRow: SignUpCellDob - 3];
        else if(signUpMode == RSUSignUpNewUser)
            [self scrollToTableRow: SignUpCellDob];
        else
            [self scrollToTableRow: SignUpCellDob - 2];
    }else if(textField == phoneField){
        if(signUpMode == RSUSignUpEditingUser)
            [self scrollToTableRow: SignUpCellPhone - 3];
        else if(signUpMode == RSUSignUpNewUser)
            [self scrollToTableRow: SignUpCellPhone];
        else
            [self scrollToTableRow: SignUpCellPhone - 2];
    }
    
    return YES;
}

- (void)jumpToNextInputFrom:(id)input{
    [countryDropTriangle setHighlighted: NO];
    [stateDropTriangle setHighlighted: NO];

    if(input == nil){
        [firstNameField becomeFirstResponder];
    }else if(input == firstNameField){
        [lastNameField becomeFirstResponder];
    }else if(input == lastNameField){
        if(signUpMode == RSUSignUpEditingUser){
            [addressField becomeFirstResponder];
        }else{
            [emailField becomeFirstResponder];
        }
    }else if(input == emailField){
        if(signUpMode == RSUSignUpSomeoneElse){
            [addressField becomeFirstResponder];
        }else{
            [passwordField becomeFirstResponder];
        }
    }else if(input == passwordField){
        [confirmPasswordField becomeFirstResponder];
    }else if(input == confirmPasswordField){
        [addressField becomeFirstResponder];
    }else if(input == addressField){
        [cityField becomeFirstResponder];
    }else if(input == cityField){
        [self showCountryPicker: nil];
    }else if(input == countryDrop){
        [self showStatePicker: nil];
    }else if(input == stateDrop){
        [zipcodeField becomeFirstResponder];
    }else if(input == zipcodeField){
        [dobField becomeFirstResponder];
    }else if(input == dobField){
        [phoneField becomeFirstResponder];
    }else if(input == phoneField){
        [self hideCurrentInput: nil];
    }
}

- (void)jumpToLastInputFrom:(id)input{
    [countryDropTriangle setHighlighted: NO];
    [stateDropTriangle setHighlighted: NO];

    if(input == nil){
        [firstNameField becomeFirstResponder];
    }else if(input == genderControl){
        [phoneField becomeFirstResponder];
    }else if(input == phoneField){
        [dobField becomeFirstResponder];
    }else if(input == dobField){
        [zipcodeField becomeFirstResponder];
    }else if(input == zipcodeField){
        [self showStatePicker: nil];
    }else if(input == stateDrop){
        [self showCountryPicker: nil];
    }else if(input == countryDrop){
        [cityField becomeFirstResponder];
    }else if(input == cityField){
        [addressField becomeFirstResponder];
    }else if(input == addressField){
        if(signUpMode == RSUSignUpEditingUser)
            [lastNameField becomeFirstResponder];
        else if(signUpMode == RSUSignUpNewUser)
            [confirmPasswordField becomeFirstResponder];
        else
            [emailField becomeFirstResponder];
    }else if(input == confirmPasswordField){
        [passwordField becomeFirstResponder];
    }else if(input == passwordField){
        [emailField becomeFirstResponder];
    }else if(input == emailField){
        [lastNameField becomeFirstResponder];
    }else if(input == lastNameField){
        [firstNameField becomeFirstResponder];
    }
}

- (IBAction)prevNextControlDidChange:(id)sender{
    NSLog(@"Current input: %@", [currentInput class]);
    if([(UISegmentedControl *)sender selectedSegmentIndex] == 0){
        [self jumpToLastInputFrom: currentInput];
    }else{
        [self jumpToNextInputFrom: currentInput];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self jumpToNextInputFrom: textField];
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    int numberOfRows = [self tableView:tableView numberOfRowsInSection:0];
    
    if(indexPath.row == 0)
        [cell setExtra: YES];
    else if(indexPath.row == 1)
        [cell setTop: YES];
    else if(indexPath.row == numberOfRows - 2)
        [cell setBottom: YES];

    if(indexPath.row == numberOfRows - 1){
        if(registerButton.superview != nil)
            [registerButton removeFromSuperview];
        [registerButton setFrame: CGRectMake(20, cellHeight / 2 - registerButton.frame.size.height / 2, 280, registerButton.frame.size.height)];
        [cell.contentView addSubview: registerButton];
        [cell setExtra: YES];
    }else if(indexPath.row != 0){
        SignUpCellControl control = SignUpCellFirstName;
        if(signUpMode == RSUSignUpEditingUser){
            control = indexPath.row;
            if(indexPath.row > 2)
                control = indexPath.row + 3;
        }else if(signUpMode == RSUSignUpNewUser){
            control = indexPath.row;
        }else if(signUpMode == RSUSignUpSomeoneElse){
            control = indexPath.row;
            if(indexPath.row > 3)
                control = indexPath.row + 2;
        }
        
        if(control == SignUpCellFirstName){
            if(firstNameField.superview != nil)
                [firstNameField removeFromSuperview];
            [firstNameField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: firstNameField];
        }else if(control == SignUpCellLastName){
            if(lastNameField.superview != nil)
                [lastNameField removeFromSuperview];
            [lastNameField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: lastNameField];
        }else if(control == SignUpCellEmail){
            if(emailField.superview != nil)
                [emailField removeFromSuperview];
            [emailField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: emailField];
        }else if(control == SignUpCellPass){
            if(passwordField.superview != nil)
                [passwordField removeFromSuperview];
            [passwordField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: passwordField];
        }else if(control == SignUpCellConfirmPass){
            if(confirmPasswordField.superview != nil)
                [confirmPasswordField removeFromSuperview];
            [confirmPasswordField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: confirmPasswordField];
        }else if(control == SignUpCellAddress){
            if(addressField.superview != nil)
                [addressField removeFromSuperview];
            [addressField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: addressField];
        }else if(control == SignUpCellCity){
            if(cityField.superview != nil)
                [cityField removeFromSuperview];
            [cityField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: cityField];
        }else if(control == SignUpCellCountry){
            if(countryDrop.superview != nil)
                [countryDrop removeFromSuperview];
            if(countryDropTriangle.superview != nil)
                [countryDropTriangle removeFromSuperview];
            [countryDrop setFrame: CGRectMake(28, 0, 264, cellHeight)];
            [countryDropTriangle setFrame: CGRectMake(255, cellHeight / 2 - countryDropTriangle.frame.size.height / 2, countryDropTriangle.frame.size.width, countryDropTriangle.frame.size.height)];
            [cell.contentView addSubview: countryDrop];
            [cell.contentView addSubview: countryDropTriangle];
        }else if(control == SignUpCellState){
            if(stateDrop.superview != nil)
                [stateDrop removeFromSuperview];
            if(stateDropTriangle.superview != nil)
                [stateDropTriangle removeFromSuperview];
            [stateDrop setFrame: CGRectMake(28, 0, 264, cellHeight)];
            [stateDropTriangle setFrame: CGRectMake(255, cellHeight / 2 - stateDropTriangle.frame.size.height / 2, stateDropTriangle.frame.size.width, stateDropTriangle.frame.size.height)];
            [cell.contentView addSubview: stateDrop];
            [cell.contentView addSubview: stateDropTriangle];
        }else if(control == SignUpCellZip){
            if(zipcodeField.superview != nil)
                [zipcodeField removeFromSuperview];
            [zipcodeField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: zipcodeField];
        }else if(control == SignUpCellDob){
            if(dobField.superview != nil)
                [dobField removeFromSuperview];
            [dobField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: dobField];
        }else if(control == SignUpCellPhone){
            if(phoneField.superview != nil)
                [phoneField removeFromSuperview];
            [phoneField setFrame: CGRectMake(36, 0, 248, cellHeight)];
            [cell.contentView addSubview: phoneField];
        }else if(control == SignUpCellGender){
            if(genderControl.superview != nil)
                [genderControl removeFromSuperview];
            if(genderUnderline.superview != nil)
                [genderUnderline removeFromSuperview];
            [genderControl setFrame: CGRectMake(20, 0, 280, cellHeight)];
            [genderUnderline setFrame: CGRectMake(68, 34, 44, 1)];
            [cell.contentView addSubview: genderControl];
            [cell.contentView addSubview: genderUnderline];
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(signUpMode == RSUSignUpEditingUser)
        return 12;
    else if(signUpMode == RSUSignUpNewUser)
        return 15;
    else if(signUpMode == RSUSignUpSomeoneElse)
        return 13;
    
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return 20;
    else if(indexPath.row != [self tableView:tableView numberOfRowsInSection:0] - 1)
        return 52;
    return 64;
}

- (IBAction)genderControlDidChange:(id)sender{
    [UIView beginAnimations:@"GenderUnderlineSwitch" context:nil];
    [UIView setAnimationDuration: 0.15f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    if([genderControl selectedSegmentIndex] == 0){
        [genderUnderline setFrame: CGRectMake(68, 34, 44, 1)];
    }else{
        [genderUnderline setFrame: CGRectMake(198, 34, 64, 1)];
    }
    [UIView commitAnimations];
}

- (IBAction)showCountryPicker:(id)sender{
    [self.view endEditing: YES];
    [countryDrop setSelected: YES];
    [stateDrop setSelected: NO];
    [countryDropTriangle setHighlighted: YES];
    [stateDropTriangle setHighlighted: NO];
    
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
        [self showBackground];
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
    }
    currentPicker = 1;
    currentInput = countryDrop;
    
    if(signUpMode == RSUSignUpEditingUser)
        [self scrollToTableRow: SignUpCellCountry - 3];
    else if(signUpMode == RSUSignUpNewUser)
        [self scrollToTableRow: SignUpCellCountry];
    else
        [self scrollToTableRow: SignUpCellCountry - 2];
}

- (IBAction)showStatePicker:(id)sender{
    [self.view endEditing: YES];
    [countryDrop setSelected: NO];
    [stateDrop setSelected: YES];
    [countryDropTriangle setHighlighted: NO];
    [stateDropTriangle setHighlighted: YES];
    if(currentPicker == 0){
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [UIView setAnimationDuration: 0.25f];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
        [UIView commitAnimations];
        [self showBackground];
    }else{
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height - 216, 320, 216)];
    }
    currentPicker = 2;
    currentInput = stateDrop;
    
    if(signUpMode == RSUSignUpEditingUser)
        [self scrollToTableRow: SignUpCellState - 3];
    else if(signUpMode == RSUSignUpNewUser)
        [self scrollToTableRow: SignUpCellState];
    else
        [self scrollToTableRow: SignUpCellState - 2];
}

- (IBAction)hideCurrentInput:(id)sender{
    if(currentPicker == 1){
        [countryDrop setSelected: NO];
        [countryDropTriangle setHighlighted: NO];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [countryPicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else if(currentPicker == 2){
        [stateDrop setSelected: NO];
        [stateDropTriangle setHighlighted: NO];
        [UIView beginAnimations:@"PickerSlide" context:nil];
        [statePicker setFrame: CGRectMake(0, [self.view frame].size.height, 320, 216)];
        [UIView commitAnimations];
    }else{
        [self.view endEditing: YES];
    }
    
    [self hideBackground];

    currentPicker = 0;
    currentInput = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
