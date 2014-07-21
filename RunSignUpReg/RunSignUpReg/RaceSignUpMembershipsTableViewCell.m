//
//  RaceSignUpMembershipsTableViewCell.m
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

#import "RaceSignUpMembershipsTableViewCell.h"

@implementation RaceSignUpMembershipsTableViewCell
@synthesize nameLabel;
@synthesize priceAdjLabel;
@synthesize additionalFieldHint;
@synthesize additionalField;
@synthesize optionalNoticeLabel;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 17, 312, 20)];
        [nameLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [nameLabel setAdjustsFontSizeToFitWidth: YES];
        [nameLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: nameLabel];
        
        self.additionalFieldHint = [[UILabel alloc] initWithFrame: CGRectMake(4, 40, 312, 20)];
        [additionalFieldHint setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [additionalFieldHint setAlpha: 0.0f];
        [self.contentView addSubview: additionalFieldHint];
        
        self.additionalField = [[UITextField alloc] initWithFrame: CGRectMake(4, 64, 312, 30)];
        [additionalField setAlpha: 0.0f];
        [additionalField setBorderStyle: UITextBorderStyleRoundedRect];
        [self.contentView addSubview: additionalField];
        
        self.optionalNoticeLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 100, 312, 30)];
        [optionalNoticeLabel setNumberOfLines: 0];
        [optionalNoticeLabel setLineBreakMode: NSLineBreakByWordWrapping];
        [optionalNoticeLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [self.contentView addSubview: optionalNoticeLabel];
        
        active = NO;
    }
    return self;
}

- (void)setActive:(BOOL)a{
    active = a;
    [UIView beginAnimations:@"Active" context:nil];
    if(active){
        [nameLabel setFrame: CGRectMake(4, 8, 312, 20)];
        [additionalFieldHint setAlpha: 1.0f];
        [additionalField setAlpha: 1.0f];
    }else{
        [nameLabel setFrame: CGRectMake(4, 17, 312, 20)];
        [additionalFieldHint setAlpha: 0.0f];
        [additionalField setAlpha: 0.0f];
    }
    [UIView commitAnimations];
}

- (void)setOptionalNoticeText:(NSString *)text{
    CGSize requiredSize = [text sizeWithFont:[UIFont fontWithName:@"OpenSans" size:18] constrainedToSize:CGSizeMake(312, INFINITY)];
    [optionalNoticeLabel setFrame: CGRectMake(4, 100, 312, requiredSize.height)];
    [optionalNoticeLabel setText: text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
