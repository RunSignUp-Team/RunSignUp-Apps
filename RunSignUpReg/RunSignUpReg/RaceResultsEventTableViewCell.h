//
//  RaceResultsEventTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceResultsEventTableViewCell : UITableViewCell{
    UILabel *placeLabel;
    UILabel *bibLabel;
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UILabel *genderLabel;
    UILabel *timeLabel;
    UILabel *paceLabel;
    UILabel *ageLabel;
}

@property (nonatomic, retain) UILabel *placeLabel;
@property (nonatomic, retain) UILabel *bibLabel;
@property (nonatomic, retain) UILabel *firstNameLabel;
@property (nonatomic, retain) UILabel *lastNameLabel;
@property (nonatomic, retain) UILabel *genderLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *paceLabel;
@property (nonatomic, retain) UILabel *ageLabel;

@end
