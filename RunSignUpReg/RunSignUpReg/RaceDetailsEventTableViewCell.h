//
//  RaceDetailsEventTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 12/22/12.
//
//

#import <UIKit/UIKit.h>

@interface RaceDetailsEventTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *timeLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *timeLabel;

@end
