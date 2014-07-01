//
//  RaceSignUpQuestionsTableViewCell.h
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

typedef enum{
    RSUQuestionTypeFreeform = 0,
    RSUQuestionTypeBoolean,
    RSUQuestionTypeSelection,
    RSUQuestionTypeRadio,
    RSUQuestionTypeCheck,
    RSUQuestionTypeTime
}RSUQuestionType;

@protocol RaceSignUpQuestionsTableViewCellDelegate <UITextFieldDelegate>

- (void)didChangeResponse:(id)response forQuestionID:(NSString *)questionID;

@end

@class RaceSignUpQuestionsViewController;

@interface RaceSignUpQuestionsTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>{
    UILabel *questionLabel;
    RSUQuestionType type;
    
    id questionID;
    
    NSArray *responses;
    NSMutableArray *selectedArray;
    
    UITextField *freeformField;
    UISegmentedControl *booleanControl;
    UITableView *selectionTable;
    UIPickerView *timePicker;
    
    NSObject<RaceSignUpQuestionsTableViewCellDelegate> *delegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) UILabel *questionLabel;
@property (nonatomic, retain) NSArray *responses;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) id questionID;
@property RSUQuestionType type;
@property (nonatomic, retain) NSObject<RaceSignUpQuestionsTableViewCellDelegate> *delegate;

- (void)setQuestionLabelText:(NSString *)text;
- (void)setFreeformKeyboardType:(UIKeyboardType)ktype;
- (void)setFreeformPlaceholderText:(NSString *)text;

- (void)reset;
- (void)setCurrentResponse:(id)resp;

- (id)response;
- (void)valueDidChange;

@end
