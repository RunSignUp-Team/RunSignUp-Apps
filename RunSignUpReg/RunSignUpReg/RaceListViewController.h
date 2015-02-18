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
#import "RaceSearchTableViewCell.h"
#import "RoundedTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

#define RESULTS_PER_PAGE 25

@interface RaceListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RaceSearchTableViewCellDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate>{
    UITableView *table;
    NSMutableDictionary *searchParams;
    
    BOOL showingAdvancedSearch;
    BOOL showingBackground;
    
    BOOL searchOpen;
    NSString *currentSearch;
    
    // Search UI elements
    float advancedSearchHeight;
    UITableView *searchTable;
    UIButton *toggleSearchButton;
    UIButton *distanceDrop;
    UIButton *countryDrop;
    UIButton *stateDrop;
    UIButton *searchButton;
    UIButton *cancelButton;
    UIButton *currentLocationButton;
    int numLocationUpdates;
    
    UIImageView *distanceDropTriangle;
    UIImageView *countryDropTriangle;
    UIImageView *stateDropTriangle;
    
    UITextField *raceNameField;
    UITextField *distanceField;
    UITextField *cityField;
    UITextField *fromDateField;
    UITextField *toDateField;
    
    UIColor *dateFieldOriginalTextColor;
    
    UIToolbar *toolbar;
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
    
    NSArray *stateArrayUSReadable;
    NSArray *stateArrayCAReadable;
    
    int currentPicker;
    NSInteger currentSelectedDistance;
    NSInteger currentSelectedCountry;
    NSInteger currentSelectedState;
    // End search UI elements
    
    UIRefreshControl *refreshControl;
    BOOL reloading;
    BOOL loadedRaces;
    BOOL firstLoad;
    
    int page;
    
    NSArray *raceList;
    
    BOOL moreResultsToShow;
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
@property (nonatomic, retain) IBOutlet UIButton *currentLocationButton;

@property (nonatomic, retain) IBOutlet UIImageView *distanceDropTriangle;
@property (nonatomic, retain) IBOutlet UIImageView *countryDropTriangle;
@property (nonatomic, retain) IBOutlet UIImageView *stateDropTriangle;

@property (nonatomic, retain) IBOutlet UITextField *raceNameField;
@property (nonatomic, retain) IBOutlet UITextField *distanceField;
@property (nonatomic, retain) IBOutlet UITextField *cityField;
@property (nonatomic, retain) IBOutlet UITextField *fromDateField;
@property (nonatomic, retain) IBOutlet UITextField *toDateField;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *prevNextControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *dateClearButton;
@property (nonatomic, retain) IBOutlet UIView *pickerBackgroundView;

@property (nonatomic, retain) IBOutlet UIPickerView *distancePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *statePicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) NSMutableDictionary *searchParams;
@property (nonatomic, retain) NSString *currentSearch;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (void)updateRaceListsIfNecessary;
- (void)retrieveRaceList;
- (void)retrieveRaceListAndAppend;

- (void)reloadRaces;
- (void)doneLoadingRaces;

- (IBAction)toggleAdvancedSearch:(id)sender;

- (IBAction)search:(id)sender;
- (IBAction)useCurrentLocation:(id)sender;

- (IBAction)hidePicker:(id)sender;
- (IBAction)showCountryPicker:(id)sender;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showDistancePicker:(id)sender;

- (IBAction)prevNextChanged:(id)sender;
- (IBAction)clearDateField:(id)sender;

- (IBAction)datePickerDidChange:(id)sender;

@end
