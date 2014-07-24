//
//  RaceSignUpEventTableViewCell.m
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

#import "RaceSignUpEventTableViewCell.h"

@implementation RaceSignUpEventTableViewCell
@synthesize nameLabel;
@synthesize priceLabel;
@synthesize priceLabel2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 0, 300, 22)];
        [nameLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [nameLabel setAdjustsFontSizeToFitWidth: YES];
        [self.contentView addSubview: nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 22, 312, 20)];
        [priceLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [priceLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel];
        
        self.priceLabel2 = [[UILabel alloc] initWithFrame: CGRectMake(4, 22, 312, 20)];
        [priceLabel2 setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        [priceLabel2 setTextColor: [UIColor colorWithRed:59/255.0f green:184/255.0f blue:224/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel2];
    }
    return self;
}

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2{
    [priceLabel setText: [NSString stringWithFormat:@"%@ Race Fee", price1]];
    if(![price2 isEqualToString:@"$0.00"]){
        CGSize size = [[priceLabel text] sizeWithFont: [priceLabel font]];
        
        [priceLabel2 setText: [NSString stringWithFormat:@"+ %@ SignUp Fee", price2]];
        [priceLabel2 setFrame: CGRectMake([priceLabel frame].origin.x + size.width + 4, [priceLabel frame].origin.y, 312 - [priceLabel frame].origin.x + size.width, 20)];
    }else{
        [priceLabel2 setText: nil];
    }
}

- (void)setShowPrice:(BOOL)showPrice{
    if(showPrice){
        [priceLabel setHidden: NO];
        [priceLabel2 setHidden: NO];
        [nameLabel setFrame: CGRectMake(4, 0, 320, 20)];
    }else{
        [priceLabel setHidden: YES];
        [priceLabel2 setHidden: YES];
        [nameLabel setFrame: CGRectMake(4, [self.contentView frame].size.height / 2 - 10, 312, 20)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [priceLabel2 setTextColor: [UIColor colorWithRed:59/255.0f green:184/255.0f blue:224/255.0f alpha:1.0f]];
    [priceLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];

    // Configure the view for the selected state
}

@end
