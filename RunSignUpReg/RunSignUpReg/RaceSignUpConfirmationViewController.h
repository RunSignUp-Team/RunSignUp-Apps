//
//  RaceSignUpConfirmationViewController.h
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

@interface RaceSignUpConfirmationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    RoundedLoadingIndicator *rli;
    
    UILabel *raceNameLabel;
    UILabel *registeredLabel;
    
    UITableView *eventsTable;
    
    UIView *registrantView;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *dobLabel;
    UILabel *genderLabel;
    UILabel *phoneLabel;
    UILabel *addressLabel;
    
    UILabel *totalLabel;
    
    UIView *otherView;
    UIView *totalView;
    UIScrollView *scrollView;
    
    UIButton *mistakeButton;
    UIButton *mainMenuButton;
    
    NSMutableDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) IBOutlet UILabel *raceNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *registeredLabel;
@property (nonatomic, retain) IBOutlet UITableView *eventsTable;

@property (nonatomic, retain) IBOutlet UIView *registrantView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipLabel;

@property (nonatomic, retain) IBOutlet UILabel *totalLabel;

@property (nonatomic, retain) IBOutlet UIView *otherView;
@property (nonatomic, retain) IBOutlet UIView *totalView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIButton *mistakeButton;
@property (nonatomic, retain) IBOutlet UIButton *mainMenuButton;

- (IBAction)returnToMainMenu:(id)sender;
- (IBAction)clearTransaction:(id)sender;

- (void)printConfirmation;

@end
