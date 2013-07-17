//
//  RaceDetailsRegistrationTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceDetailsRegistrationTableViewCell : UITableViewCell{
    UILabel *titleLabel;
    
    UILabel *periodLabel;
    UILabel *priceLabel;
    UILabel *priceLabel2;
}

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *periodLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *priceLabel2;

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2;

@end
