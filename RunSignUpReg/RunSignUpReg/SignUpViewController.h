//
//  SignUpViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@class ProfileViewController;

@interface SignUpViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    UIScrollView *scrollView;
    
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
    
    UIToolbar *donePickerBar;
    
    UIPickerView *countryPicker;
    UIPickerView *statePicker;
    
    NSArray *countryArray;
    NSArray *stateArrayUS;
    NSArray *stateArrayCA;
    NSArray *stateArrayGE;
    
    BOOL isEditingUserProfile;
    NSDictionary *userDictionary;
    
    int currentPicker;
    NSInteger currentSelectedCountry;
    NSInteger currentSelectedState;
    
    ProfileViewController *profileViewController;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
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
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *chooseExistingButton;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UIToolbar *donePickerBar;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;

@property BOOL isEditingUserProfile;
@property (nonatomic, retain) NSDictionary *userDictionary;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profileViewController:(ProfileViewController *)pvc;

- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseExistingPhoto:(id)sender;

- (IBAction)saveProfile:(id)sender;

- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)hideCurrentInput:(id)sender;

@end
