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

@interface RaceListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    NSMutableDictionary *searchParams;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    
    NSArray *raceList;
    BOOL moreResultsToRetrieve;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableDictionary *searchParams;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (void)retrieveRaceList;
- (void)retrieveRaceListAndAppend;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData:(BOOL)scroll;

- (IBAction)showSearchParams:(id)sender;
- (IBAction)clearSearchParams:(id)sender;

@end
