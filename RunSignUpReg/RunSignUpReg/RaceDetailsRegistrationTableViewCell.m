//
//  RaceDetailsRegistrationTableViewCell.m
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

#import "RaceDetailsRegistrationTableViewCell.h"

@implementation RaceDetailsRegistrationTableViewCell
@synthesize titleLabel;
@synthesize startTimeLabel;
@synthesize priceLabel;
@synthesize priceLabel2;
@synthesize increaseLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, [self frame].size.width - 8, 26)];
        [titleLabel setFont: [UIFont fontWithName:@"OpenSans-Semibold" size:18]];
        [titleLabel setTextColor: [UIColor colorWithRed:0.0f green: 148/255.0f blue:204/255.0f alpha:1.0f]];
        [titleLabel setAdjustsFontSizeToFitWidth: YES];
        [self.contentView addSubview: titleLabel];
        
        self.startTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 26, [self frame].size.width - 8, 20)];
        [startTimeLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [startTimeLabel setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        [self.contentView addSubview: startTimeLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 46, [self frame].size.width - 8, 22)];
        [priceLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [priceLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel];
        
        self.priceLabel2 = [[UILabel alloc] initWithFrame: CGRectMake(0, 46, [self frame].size.width - 8, 22)];
        [priceLabel2 setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [priceLabel2 setTextColor: [UIColor colorWithRed:59/255.0f green:184/255.0f blue:224/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel2];
        
        self.increaseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 68, [self frame].size.width - 8, 44)];
        [increaseLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [increaseLabel setNumberOfLines: 0];
        [increaseLabel setLineBreakMode: NSLineBreakByWordWrapping];
        [increaseLabel setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        [self.contentView addSubview: increaseLabel];
    }
    return self;
}

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2{
    [priceLabel setText: [NSString stringWithFormat:@"%@ Race Fee", price1]];
    if(![price2 isEqualToString:@"$0.00"]){
        CGSize size = [[priceLabel text] sizeWithFont: [priceLabel font]];
        [priceLabel2 setText: [NSString stringWithFormat:@"+ %@ SignUp Fee", price2]];
        [priceLabel2 setFrame: CGRectMake(priceLabel.frame.origin.x + size.width + 4, priceLabel.frame.origin.y, [self frame].size.width - 8 - [priceLabel frame].origin.x + size.width, 22)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
