//
//  RaceSignUpGiveawayTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpGiveawayTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *pickerView;
    NSArray *giveawayOptions;
}

- (void)setGiveawayOptions:(NSArray *)go;
- (NSString *)getSelectedGiveawayID;

@end
