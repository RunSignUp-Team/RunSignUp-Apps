//
//  RaceSignUpMembershipsViewController.h
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
#import "RaceSignUpMembershipsTableViewCell.h"

@interface RaceSignUpMembershipsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RaceSignUpMembershipsTableViewCellDelegate>{
    NSMutableDictionary *dataDict;
    UITableView *table;
    
    UITextField *currentTextField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;

- (IBAction)chooseMemberships:(id)sender;

@end
