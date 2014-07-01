//
//  RaceSearchViewController.h
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

@class RaceListViewController;

@interface RaceSearchViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>{
    UIButton *distanceDrop;
    UIButton *countryDrop;
    UIButton *stateDrop;
    UIButton *searchButton;
    UIButton *cancelButton;
    
    UITextField *raceNameField;
    UITextField *distanceField;
    UITextField *fromDateField;
    UITextField *toDateField;
    
    UIView *pickerBackgroundView;
    
    UIPickerView *distancePicker;
    UIPickerView *countryPicker;
    UIPickerView *statePicker;
    UIDatePicker *datePicker;
    
    NSArray *distanceArray;
    NSArray *countryArray;
    NSArray *stateArrayUS;
    NSArray *stateArrayCA;
    NSArray *stateArrayGE;
    
    RaceListViewController *delegate;
    
    int currentPicker;
    NSInteger currentSelectedDistance;
    NSInteger currentSelectedCountry;
    NSInteger currentSelectedState;
}

@property (nonatomic, retain) IBOutlet UIButton *distanceDrop;
@property (nonatomic, retain) IBOutlet UIButton *countryDrop;
@property (nonatomic, retain) IBOutlet UIButton *stateDrop;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UITextField *raceNameField;
@property (nonatomic, retain) IBOutlet UITextField *distanceField;
@property (nonatomic, retain) IBOutlet UITextField *fromDateField;
@property (nonatomic, retain) IBOutlet UITextField *toDateField;

@property (nonatomic, retain) IBOutlet UIView *pickerBackgroundView;

@property (nonatomic, retain) IBOutlet UIPickerView *distancePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) RaceListViewController *delegate;

- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showDistancePicker:(id)sender;

- (IBAction)datePickerDidChange:(id)sender;

- (void)showAlertFor:(NSString *)reason;

@end
