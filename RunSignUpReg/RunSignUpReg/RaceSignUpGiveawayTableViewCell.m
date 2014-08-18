//
//  RaceSignUpGiveawayTableViewCell.m
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

#import "RaceSignUpGiveawayTableViewCell.h"

@implementation RaceSignUpGiveawayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        giveawayOptions = nil;
        
        pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(4, 4, 312, 216)];
        [pickerView setDelegate: self];
        [pickerView setDataSource: self];
        [pickerView setShowsSelectionIndicator: YES];
        [self.contentView addSubview: pickerView];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [giveawayOptions count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *rowText = [NSString stringWithFormat: @"%@ - %@", [[giveawayOptions objectAtIndex: row] objectForKey:@"giveaway_option_text"], [[giveawayOptions objectAtIndex: row] objectForKey:@"additional_cost"]];
    
    if(view == nil){
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 312, 22)];
        [label setTextAlignment: NSTextAlignmentCenter];
        [label setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setText: rowText];
        return label;
    }else{
        UILabel *label = (UILabel *)view;
        [label setText: rowText];
        return label;
    }
}

- (void)setGiveawayOptions:(NSArray *)go{
    giveawayOptions = go;
}

- (NSString *)getSelectedGiveawayID{
    if(giveawayOptions != nil)
        return [[giveawayOptions objectAtIndex: [pickerView selectedRowInComponent: 0]] objectForKey: @"giveaway_option_id"];
    else
        return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
