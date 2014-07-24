//
//  RaceDetailsRegistrationTableViewCell.h
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

@interface RaceDetailsRegistrationTableViewCell : UITableViewCell{
    UILabel *titleLabel;
    UILabel *startTimeLabel;
    UILabel *priceLabel;
    UILabel *priceLabel2;
    UILabel *increaseLabel;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *startTimeLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *priceLabel2;
@property (nonatomic, retain) UILabel *increaseLabel;

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2;

@end
