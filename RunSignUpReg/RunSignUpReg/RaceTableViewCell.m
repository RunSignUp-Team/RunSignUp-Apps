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
#import "RSUModel.h"

@implementation RaceTableViewCell
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize locationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 12, 296, 20)];
        //[dateLabel setBackgroundColor: [UIColor redColor]];
        [dateLabel setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        [dateLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [dateLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: dateLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 42, 296, 26)];
        [nameLabel setFont: [UIFont fontWithName:@"Sanchez-Regular" size:20]];
        [nameLabel setNumberOfLines: 0];
        [nameLabel setLineBreakMode: NSLineBreakByWordWrapping];
        [nameLabel setTextColor: [UIColor colorWithRed:53/255.0f green:165/255.0f blue:219/255.0f alpha:1.0f]];
        [nameLabel setUserInteractionEnabled: NO];
        [nameLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: nameLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame: CGRectMake(12, 74, 296, 24)];
        //[locationLabel setBackgroundColor: [UIColor redColor]];
        [locationLabel setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        [locationLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [locationLabel setAdjustsFontSizeToFitWidth: YES];
        [locationLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: locationLabel];
        
        /*self.descriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 100, 312, 96)];
        //[descriptionLabel setBackgroundColor: [UIColor redColor]];
        [descriptionLabel setNumberOfLines: 0];
        [descriptionLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [descriptionLabel setTextColor: [UIColor colorWithWhite:0.3686f alpha:1.0f]];
        [self.contentView addSubview: descriptionLabel];*/        
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    [nameLabel setText: [data objectForKey: @"name"]];
    CGSize reqSize = [[nameLabel text] sizeWithFont:[UIFont fontWithName:@"Sanchez-Regular" size:20] constrainedToSize:CGSizeMake(296, 100)];
    [nameLabel setFrame: CGRectMake(12, 42, 296, reqSize.height)];
    [locationLabel setFrame: CGRectMake(12, 48 + reqSize.height, 296, 24)];
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM/dd/yyyy"];
    NSDate *date = nil;
    if([data objectForKey: @"next_date"])
        date = [dateFormatter dateFromString: [data objectForKey: @"next_date"]];
    else if([data objectForKey: @"last_date"])
        date = [dateFormatter dateFromString: [data objectForKey: @"last_date"]];
    
    [dateFormatter setDateFormat: @"EEEE MM/dd/yyyy"];
    [dateLabel setText: [dateFormatter stringFromDate: date]];
    [locationLabel setText: [RSUModel addressLine2FromAddress: [data objectForKey: @"address"]]];
    
    if([data objectForKey: @"active_race"]){
        [nameLabel setTextColor: [UIColor redColor]];
    }else{
        [nameLabel setTextColor: [UIColor colorWithRed:53/255.0f green:165/255.0f blue:219/255.0f alpha:1.0f]];
    }
     
    [dateFormatter release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    /*[UIView beginAnimations:@"SelectionFade" context:nil];
    [UIView setAnimationDuration: 0.25f];
    if(selected){
        [nameLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
    }else{
        [nameLabel setTextColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
    }
    [UIView commitAnimations];*/
}

/*- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [UIView beginAnimations:@"SelectionFade" context:nil];
    [UIView setAnimationDuration: 0.25f];
    if(highlighted){
        [nameLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithWhite:1.0f alpha:1.0f]];
    }else{
        [nameLabel setTextColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]]; 
        [dateLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
        [locationLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
    }
    [UIView commitAnimations];
}*/

@end
