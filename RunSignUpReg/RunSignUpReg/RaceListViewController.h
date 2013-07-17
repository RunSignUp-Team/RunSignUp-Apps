//
//  RaceListViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
