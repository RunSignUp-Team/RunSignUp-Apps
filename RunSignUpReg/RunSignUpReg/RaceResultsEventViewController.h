//
//  RaceResultsEventViewController.h
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

@interface RaceResultsEventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    NSDictionary *dataDict;
    NSArray *results;
    
    BOOL moreResultsToRetrieve;
    int page;
    
    RoundedLoadingIndicator *rli;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;
@property (nonatomic, retain) NSArray *results;

@end
