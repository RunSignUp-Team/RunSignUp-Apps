//
//  RaceResultsEventTableViewCell.m
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

#import "RaceResultsEventTableViewCell.h"

@implementation RaceResultsEventTableViewCell
@synthesize placeLabel;
@synthesize bibLabel;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize genderLabel;
@synthesize timeLabel;
@synthesize paceLabel;
@synthesize ageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float widths[] = {0.125f, 0.125f, 0.26875f, 0.11875f, 0.125f, 0.1125f, 0.1125f}; // floats derived from above divided by 320 (old iphone screen width)
        int cumWidth = 4;
        
        float fontSize = 11.0f;
        float labelHeight = self.frame.size.height / 2.0f - (fontSize + 2.0f) / 2.0f;
        
        for(int x = 0; x <= 7; x++){
            UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(cumWidth, 0, 1, [self frame].size.height)];
            [divider setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
            [divider setTag: kDividerTag];
            [self.contentView addSubview: divider];
            [divider release];
            
            if(x < 7 && x != 2){
                UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(cumWidth + 4, labelHeight, widths[x] * screenWidth - 8, fontSize + 2)];
                if(x == 0)
                    self.placeLabel = label;
                else if(x == 1)
                    self.bibLabel = label;
                else if(x == 3)
                    self.genderLabel = label;
                else if(x == 4)
                    self.timeLabel = label;
                else if(x == 5)
                    self.paceLabel = label;
                else if(x == 6)
                    self.ageLabel = label;
            }else if(x == 2){
                self.firstNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(cumWidth + 4, labelHeight - (fontSize + 4.0f) / 2.0f - 2, widths[x] * screenWidth - 8, fontSize + 4)];
                self.lastNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(cumWidth + 4, labelHeight + (fontSize + 4.0f) / 2.0f + 2, widths[x] * screenWidth - 8, fontSize + 4)];
            }
            
            cumWidth += widths[x] * screenWidth;
        }
        
        
        UIView *separator = [[UIView alloc] initWithFrame: CGRectMake(4, [self frame].size.height - 1, screenWidth - 8, 1)];
        [separator setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
        [self.contentView addSubview: separator];
        [separator release];
        
        /*self.placeLabel = [[UILabel alloc] initWithFrame: CGRectMake(8, labelHeight, 35, fontSize + 2)];
        self.bibLabel = [[UILabel alloc] initWithFrame: CGRectMake(48, labelHeight, 35, fontSize + 2)];
        self.firstNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(88, labelHeight - (fontSize + 4.0f) / 2.0f - 2, 80, fontSize + 4)];
        self.lastNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(88, labelHeight + (fontSize + 4.0f) / 2.0f + 2, 80, fontSize + 4)];
        self.genderLabel = [[UILabel alloc] initWithFrame: CGRectMake(173, labelHeight, 33, fontSize + 2)];
        self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(211, labelHeight, 35, fontSize + 2)];
        self.paceLabel = [[UILabel alloc] initWithFrame: CGRectMake(251, labelHeight, 32, fontSize + 2)];
        self.ageLabel = [[UILabel alloc] initWithFrame: CGRectMake(288, labelHeight, 27, fontSize + 2)];*/
        
        [placeLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [bibLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [firstNameLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [lastNameLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [genderLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [timeLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [paceLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        [ageLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
        
        [timeLabel setAdjustsFontSizeToFitWidth: YES];
        [paceLabel setAdjustsFontSizeToFitWidth: YES];
        
        [placeLabel setTextAlignment: NSTextAlignmentCenter];
        [genderLabel setTextAlignment: NSTextAlignmentCenter];
        [ageLabel setTextAlignment: NSTextAlignmentCenter];
        [bibLabel setTextAlignment: NSTextAlignmentCenter];
        
        [placeLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [bibLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [firstNameLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [lastNameLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [genderLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [timeLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [paceLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [ageLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        
        /*[placeLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [bibLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [firstNameLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [lastNameLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [genderLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [timeLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [paceLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [ageLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];*/
        
        [self.contentView addSubview: placeLabel];
        [self.contentView addSubview: bibLabel];
        [self.contentView addSubview: firstNameLabel];
        [self.contentView addSubview: lastNameLabel];
        [self.contentView addSubview: genderLabel];
        [self.contentView addSubview: timeLabel];
        [self.contentView addSubview: paceLabel];
        [self.contentView addSubview: ageLabel];
        
        [[self textLabel] setTextAlignment: NSTextAlignmentCenter];
    }
    return self;
}

- (void)hideDividers{
    for(UIView *divider in [self.contentView subviews]){
        if([divider tag] == kDividerTag)
            [divider setHidden: YES];
    }
}

- (void)showDividers{
    for(UIView *divider in [self.contentView subviews]){
        if([divider tag] == kDividerTag)
            [divider setHidden: NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self setHighlighted:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [UIView beginAnimations:@"Highlight" context:nil];
    if(highlighted){
        for(UIView *view in self.contentView.subviews){
            if([view isKindOfClass: [UILabel class]]){
                [(UILabel *)view setTextColor: [UIColor whiteColor]];
            }
        }
    }else{
        for(UIView *view in self.contentView.subviews){
            if([view isKindOfClass: [UILabel class]]){
                [(UILabel *)view setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
            }
        }
    }
    [UIView commitAnimations];
}

@end
