//
//  RaceSignUpMembershipsTableViewCell.h
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

@protocol RaceSignUpMembershipsTableViewCellDelegate <UITextFieldDelegate>

@end

@interface RaceSignUpMembershipsTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *priceAdjLabel;
    
    NSObject<RaceSignUpMembershipsTableViewCellDelegate> *delegate;
    
    BOOL active;
    
    UILabel *additionalFieldHint;
    UITextField *additionalField;
    UILabel *optionalNoticeLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *priceAdjLabel;
@property (nonatomic, retain) UILabel *additionalFieldHint;
@property (nonatomic, retain) UITextField *additionalField;
@property (nonatomic, retain) UILabel *optionalNoticeLabel;

@property (nonatomic, retain) NSObject<RaceSignUpMembershipsTableViewCellDelegate> *delegate;

- (void)setActive:(BOOL)a;
- (void)setOptionalNoticeText:(NSString *)text;

@end
