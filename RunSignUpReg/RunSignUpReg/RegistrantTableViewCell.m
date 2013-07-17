//
//  RegistrantTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrantTableViewCell.h"

@implementation RegistrantTableViewCell
@synthesize nameLabel;
@synthesize emailLabel;
@synthesize dobLabel;
@synthesize ageLabel;
@synthesize genderLabel;
@synthesize phoneLabel;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize zipcodeLabel;
@synthesize eventLabel;
@synthesize shirtLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UILabel *nameHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4, 100, 16)];
        [nameHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [nameHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [nameHintLabel setText: @"Name:"];
        [self.contentView addSubview: nameHintLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(108, 4, 204, 16)];
        [nameLabel setTextColor: [UIColor colorWithWhite:0.3686f alpha:1.0f]];
        [nameLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [self.contentView addSubview: nameLabel];
        
        UILabel *emailHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 24, 100, 16)];
        [emailHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [emailHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [emailHintLabel setText: @"E-mail:"];
        [self.contentView addSubview: emailHintLabel];
        
        UILabel *dobHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 44, 100, 16)];
        [dobHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [dobHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [dobHintLabel setText: @"Date of Birth:"];
        [self.contentView addSubview: dobHintLabel];
        
        UILabel *ageHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 64, 100, 16)];
        [ageHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [ageHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [ageHintLabel setText: @"Age:"];
        [self.contentView addSubview: ageHintLabel];
        
        UILabel *genderHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 84, 100, 16)];
        [genderHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [genderHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [genderHintLabel setText: @"Gender:"];
        [self.contentView addSubview: genderHintLabel];
        
        UILabel *phoneHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 104, 100, 16)];
        [phoneHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [phoneHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [phoneHintLabel setText: @"Phone:"];
        [self.contentView addSubview: phoneHintLabel];
        
        UILabel *addressHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 124, 100, 16)];
        [addressHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [addressHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [addressHintLabel setText: @"Address:"];
        [self.contentView addSubview: addressHintLabel];
        
        UILabel *cityHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 144, 100, 16)];
        [cityHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [cityHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [cityHintLabel setText: @"City:"];
        [self.contentView addSubview: cityHintLabel];
        
        UILabel *stateHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 164, 100, 16)];
        [stateHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [stateHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [stateHintLabel setText: @"State:"];
        [self.contentView addSubview: stateHintLabel];
        
        UILabel *zipcodeHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 184, 100, 16)];
        [zipcodeHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [zipcodeHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [zipcodeHintLabel setText: @"Zip Code:"];
        [self.contentView addSubview: zipcodeHintLabel];
        
        UILabel *eventHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 204, 100, 16)];
        [eventHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [eventHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [eventHintLabel setText: @"Event:"];
        [self.contentView addSubview: eventHintLabel];
        
        UILabel *shirtHintLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 224, 100, 16)];
        [shirtHintLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [shirtHintLabel setFont: [UIFont systemFontOfSize:15.0f]];
        [shirtHintLabel setText: @"T-Shirt:"];
        [self.contentView addSubview: shirtHintLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
