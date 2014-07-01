//
//  RaceResultsEventTableViewCell.h
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

#define kDividerTag 29

@interface RaceResultsEventTableViewCell : UITableViewCell{
    UILabel *placeLabel;
    UILabel *bibLabel;
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UILabel *genderLabel;
    UILabel *timeLabel;
    UILabel *paceLabel;
    UILabel *ageLabel;
}

@property (nonatomic, retain) UILabel *placeLabel;
@property (nonatomic, retain) UILabel *bibLabel;
@property (nonatomic, retain) UILabel *firstNameLabel;
@property (nonatomic, retain) UILabel *lastNameLabel;
@property (nonatomic, retain) UILabel *genderLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *paceLabel;
@property (nonatomic, retain) UILabel *ageLabel;

- (void)hideDividers;
- (void)showDividers;

@end
