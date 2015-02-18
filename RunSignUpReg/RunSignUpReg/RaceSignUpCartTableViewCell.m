//
//  RaceSignUpCartTableViewCell.m
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

#import "RaceSignUpCartTableViewCell.h"

@implementation RaceSignUpCartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        infoLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4, 250, 20)];
        [infoLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [self.contentView addSubview: infoLabel];
        
        totalCostLabel = [[UILabel alloc] initWithFrame: CGRectMake(252, 4, 64, 20)];
        [totalCostLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [totalCostLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: totalCostLabel];
        
        subitemsLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 28, [self frame].size.width - 8, 20)];
        [subitemsLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [self.contentView addSubview: subitemsLabel];
    }
    return self;
}

- (void)setInfo:(NSString *)info total:(NSString *)total subitems:(NSString *)subitems{
    [infoLabel setText: info];
    [totalCostLabel setText: total];
    
    if([subitems length] > 0)
        [subitemsLabel setText: [NSString stringWithFormat:@"  • %@", subitems]];
    else
        [subitemsLabel setText: @""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
