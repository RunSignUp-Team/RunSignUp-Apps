//
//  RaceTableViewCell.m
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

#import "RaceTableViewCell.h"

@implementation RaceTableViewCell
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize locationLabel;
@synthesize descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4, 312, 44)];
       // [nameLabel setBackgroundColor: [UIColor redColor]];
        //[nameLabel setText: @"Camarillo OffRoad 5K"];
        [nameLabel setFont: [UIFont boldSystemFontOfSize: 18.0f]];
        [nameLabel setNumberOfLines: 2];
        [nameLabel setTextColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]]; 
        [nameLabel setUserInteractionEnabled: NO];
        [self.contentView addSubview: nameLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 52, 312, 22)];
        //[dateLabel setBackgroundColor: [UIColor redColor]];
        [dateLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [dateLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [self.contentView addSubview: dateLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 76, 312, 22)];
        //[locationLabel setBackgroundColor: [UIColor redColor]];
        [locationLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [locationLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [self.contentView addSubview: locationLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 100, 312, 96)];
        //[descriptionLabel setBackgroundColor: [UIColor redColor]];
        [descriptionLabel setNumberOfLines: 0];
        [descriptionLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:0.3686f alpha:1.0f]];
        [self.contentView addSubview: descriptionLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [UIView beginAnimations:@"SelectionFade" context:nil];
    [UIView setAnimationDuration: 0.25f];
    if(selected){
        [nameLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
    }else{
        [nameLabel setTextColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:0.3686f alpha:1.0f]];
    }
    [UIView commitAnimations];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [UIView beginAnimations:@"SelectionFade" context:nil];
    [UIView setAnimationDuration: 0.25f];
    if(highlighted){
        [nameLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
    }else{
        [nameLabel setTextColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:0.3686f alpha:1.0f]];
    }
    [UIView commitAnimations];

}

@end
