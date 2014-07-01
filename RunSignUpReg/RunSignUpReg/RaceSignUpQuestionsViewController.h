//
//  RaceSignUpQuestionsViewController.h
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
#import "RaceSignUpQuestionsTableViewCell.h"
#import "RaceSignUpCartTableViewCell.h"

@interface RaceSignUpQuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RaceSignUpQuestionsTableViewCellDelegate>{
    NSMutableDictionary *dataDict;
    
    NSMutableArray *responses;
    
    UITextField *currentTextField;
    UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *responses;

- (IBAction)answerQuestions:(id)sender;
- (void)hideKeyboard;

@end
