//
//  RaceSignUpCartTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpCartTableViewCell : UITableViewCell{
    UILabel *infoLabel;
    UILabel *totalCostLabel;
    
    UILabel *subitemsLabel;
}

- (void)setInfo:(NSString *)info total:(NSString *)total subitems:(NSString *)subitems;

@end
