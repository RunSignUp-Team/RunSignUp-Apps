//
//  RegistrantTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrantTableViewCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *dobLabel;
    UILabel *ageLabel;
    UILabel *genderLabel;
    UILabel *phoneLabel;
    UILabel *addressLabel;
    UILabel *cityLabel;
    UILabel *stateLabel;
    UILabel *zipcodeLabel;
    UILabel *eventLabel;
    UILabel *shirtLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UILabel *ageLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipcodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *eventLabel;
@property (nonatomic, retain) IBOutlet UILabel *shirtLabel;

@end
