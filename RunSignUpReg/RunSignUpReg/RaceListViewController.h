//
//  RaceListViewController.h
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
#import "EGORefreshTableHeaderView.h"
#import "RaceSearchTableViewCell.h"
#import "RaceSearchRoundedTableViewCell.h"

@interface RaceListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, RaceSearchTableViewCellDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UITableView *table;
    NSMutableDictionary *searchParams;
    
    BOOL showingAdvancedSearch;
    BOOL showingBackground;
    
    // Search UI elements
    float advancedSearchHeight;
    UITableView *searchTable;
    UIButton *toggleSearchButton;
    UIButton *distanceDrop;
    UIButton *countryDrop;
    UIButton *stateDrop;
    UIButton *searchButton;
    UIButton *cancelButton;
    
    UIImageView *distanceDropTriangle;
    UIImageView *countryDropTriangle;
    UIImageView *stateDropTriangle;
    
    UITextField *raceNameField;
    UITextField *distanceField;
    UITextField *cityField;
    UITextField *fromDateField;
    UITextField *toDateField;
    
    UIColor *dateFieldOriginalTextColor;
    
    UISegmentedControl *prevNextControl;
    UIBarButtonItem *dateClearButton;
    
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
    
    int currentPicker;
    NSInteger currentSelectedDistance;
    NSInteger currentSelectedCountry;
    NSInteger currentSelectedState;
    // End search UI elements
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    
    NSArray *raceList;
    BOOL moreResultsToRetrieve;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITableView *searchTable;
@property (nonatomic, retain) IBOutlet UIButton *toggleSearchButton;
@property (nonatomic, retain) IBOutlet UIButton *distanceDrop;
@property (nonatomic, retain) IBOutlet UIButton *countryDrop;
@property (nonatomic, retain) IBOutlet UIButton *stateDrop;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UIImageView *distanceDropTriangle;
@property (nonatomic, retain) IBOutlet UIImageView *countryDropTriangle;
@property (nonatomic, retain) IBOutlet UIImageView *stateDropTriangle;

@property (nonatomic, retain) IBOutlet UITextField *raceNameField;
@property (nonatomic, retain) IBOutlet UITextField *distanceField;
@property (nonatomic, retain) IBOutlet UITextField *cityField;
@property (nonatomic, retain) IBOutlet UITextField *fromDateField;
@property (nonatomic, retain) IBOutlet UITextField *toDateField;

@property (nonatomic, retain) IBOutlet UISegmentedControl *prevNextControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *dateClearButton;
@property (nonatomic, retain) IBOutlet UIView *pickerBackgroundView;

@property (nonatomic, retain) IBOutlet UIPickerView *distancePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) NSMutableDictionary *searchParams;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (void)retrieveRaceList;
- (void)retrieveRaceListAndAppend;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData:(BOOL)scroll;

- (IBAction)toggleAdvancedSearch:(id)sender;

- (IBAction)search:(id)sender;

- (IBAction)hidePicker:(id)sender;
- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showDistancePicker:(id)sender;

- (IBAction)prevNextChanged:(id)sender;
- (IBAction)clearDateField:(id)sender;

- (IBAction)datePickerDidChange:(id)sender;

@end
