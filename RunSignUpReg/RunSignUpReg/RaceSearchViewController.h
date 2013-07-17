//
//  RaceSearchViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
    
    UIPickerView *distancePicker;
    UIPickerView *countryPicker;
    UIPickerView *statePicker;
    
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

@property (nonatomic, retain) IBOutlet UIPickerView *distancePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;

@property (nonatomic, retain) RaceListViewController *delegate;

- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showDistancePicker:(id)sender;

- (void)showAlertFor:(NSString *)reason;

@end
