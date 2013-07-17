//
//  RaceSignUpEventTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpEventTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *priceLabel2;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *priceLabel2;

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2;

@end
