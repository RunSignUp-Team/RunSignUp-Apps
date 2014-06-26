//
//  RaceSignUpMembershipsTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/9/14.
//
//

#import <UIKit/UIKit.h>

@protocol RaceSignUpMembershipsTableViewCellDelegate <UITextFieldDelegate>

@end

@interface RaceSignUpMembershipsTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *priceAdjLabel;
    
    NSObject<RaceSignUpMembershipsTableViewCellDelegate> *delegate;
    
    BOOL active;
    
    UILabel *additionalFieldHint;
    UITextField *additionalField;
    UILabel *optionalNoticeLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *priceAdjLabel;
@property (nonatomic, retain) UILabel *additionalFieldHint;
@property (nonatomic, retain) UITextField *additionalField;
@property (nonatomic, retain) UILabel *optionalNoticeLabel;

@property (nonatomic, retain) NSObject<RaceSignUpMembershipsTableViewCellDelegate> *delegate;

- (void)setActive:(BOOL)a;
- (void)setOptionalNoticeText:(NSString *)text;

@end
