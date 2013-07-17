//
//  ProfileViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController{
    UILabel *nameLabel;
    UILabel *propicLabel;
    
    NSDictionary *userDictionary;
    BOOL isUserProfile;
    
    UILabel *emailLabel;
    UILabel *addressLine1Label;
    UILabel *addressLine2Label;
    UILabel *phoneLabel;
    UILabel *genderLabel;
    UILabel *dobLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *propicLabel;

@property (nonatomic, retain) NSDictionary *userDictionary;
@property BOOL isUserProfile;

@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLine1Label;
@property (nonatomic, retain) IBOutlet UILabel *addressLine2Label;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;

- (void)editProfile;
- (void)updateDataWithUserDictionary;

@end
