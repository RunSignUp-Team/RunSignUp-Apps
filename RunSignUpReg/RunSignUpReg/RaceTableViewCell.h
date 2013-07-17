//
//  RaceTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *locationLabel;
    UILabel *descriptionLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;


@end
