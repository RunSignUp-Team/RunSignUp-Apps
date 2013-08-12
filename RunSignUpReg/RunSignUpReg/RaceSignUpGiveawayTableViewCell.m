//
//  RaceSignUpGiveawayTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import "RaceSignUpGiveawayTableViewCell.h"

@implementation RaceSignUpGiveawayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        giveawayOptions = nil;
        
        pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(4, 4, 260, 216)];
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat: @"%@ - %@", [[giveawayOptions objectAtIndex: row] objectForKey:@"GiveawayOptionText"], [[giveawayOptions objectAtIndex: row] objectForKey:@"GiveawayAdditionalCost"]];
}

- (void)setGiveawayOptions:(NSArray *)go{
    giveawayOptions = go;
}

- (NSString *)getSelectedGiveawayID{
    if(giveawayOptions != nil)
        return [[giveawayOptions objectAtIndex: [pickerView selectedRowInComponent: 0]] objectForKey: @"GiveawayOptionID"];
    else
        return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
