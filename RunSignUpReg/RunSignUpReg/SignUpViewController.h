//
//  SignUpViewController.h
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

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

typedef enum{
    RSUSignUpEditingUser = 30,
    RSUSignUpSomeoneElse,
    RSUSignUpNewUser,
}RSUSignUpMode;

@protocol SignUpViewControllerDelegate <NSObject>

- (void)didSignUpWithDictionary:(NSDictionary *)dict;

@end

@class ProfileViewController;

typedef enum{
    SignUpCellFirstName = 1,
    SignUpCellLastName,
    SignUpCellEmail,
    SignUpCellPass,
    SignUpCellConfirmPass,
    SignUpCellAddress,
    SignUpCellCity,
    SignUpCellCountry,
    SignUpCellState,
    SignUpCellZip,
    SignUpCellDob,
    SignUpCellPhone,
    SignUpCellGender
}SignUpCellControl;

@interface SignUpViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    UITableView *table;
    
    UITextField *firstNameField;
    UITextField *lastNameField;
    UITextField *emailField;
    UITextField *passwordField;
    UITextField *confirmPasswordField;
    UITextField *addressField;
    UITextField *cityField;
    UIButton *countryDrop;
    UIButton *stateDrop;
    UITextField *zipcodeField;
    UITextField *dobField;
    UITextField *phoneField;
    UISegmentedControl *genderControl;
    
    UIButton *registerButton;
    UIButton *takePhotoButton;
    UIButton *chooseExistingButton;
    UIImageView *profileImageView;
    
    UIView *pickerBackgroundView;
    
    UIPickerView *countryPicker;
    UIPickerView *statePicker;
    
    NSArray *countryArray;
    NSArray *stateArrayUS;
    NSArray *stateArrayCA;
    NSArray *stateArrayGE;
    
    RSUSignUpMode signUpMode;
    NSDictionary *userDictionary;
    
    BOOL showingBackground;
    id currentInput;
    
    int currentPicker;
    NSInteger currentSelectedCountry;
    NSInteger currentSelectedState;
    
    UILabel *ageHintLabel;
    
    UINavigationBar *navigationBar;
    
    UIViewController<SignUpViewControllerDelegate> *delegate;
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) UIViewController<SignUpViewControllerDelegate> *delegate;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextField *firstNameField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *confirmPasswordField;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UITextField *cityField;
@property (nonatomic, retain) IBOutlet UIButton *countryDrop;
@property (nonatomic, retain) IBOutlet UIButton *stateDrop;
@property (nonatomic, retain) IBOutlet UITextField *zipcodeField;
@property (nonatomic, retain) IBOutlet UITextField *dobField;
@property (nonatomic, retain) IBOutlet UITextField *phoneField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderControl;
@property (nonatomic, retain) IBOutlet UIView *genderUnderline;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *chooseExistingButton;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UIView *pickerBackgroundView;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;

@property RSUSignUpMode signUpMode;
@property (nonatomic, retain) IBOutlet UILabel *ageHintLabel;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) NSDictionary *userDictionary;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) ProfileViewController *profileViewController;

- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseExistingPhoto:(id)sender;

- (IBAction)saveProfile:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)prevNextControlDidChange:(id)sender;
- (IBAction)genderControlDidChange:(id)sender;

- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)hideCurrentInput:(id)sender;

@end
