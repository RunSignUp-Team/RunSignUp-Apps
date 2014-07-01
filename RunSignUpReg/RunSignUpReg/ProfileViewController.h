//
//  ProfileViewController.h
//  RunSignUpReg
//
// Copyright 2014 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "RoundedLoadingIndicator.h"

@interface ProfileViewController : UIViewController <SignUpViewControllerDelegate>{
    RoundedLoadingIndicator *rli;
    
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
    UIImageView *profileImageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isUserProfile:(BOOL)iup;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *propicLabel;

@property (nonatomic, retain) NSDictionary *userDictionary;
@property BOOL isUserProfile;

@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLine1Label;
@property (nonatomic, retain) IBOutlet UILabel *addressLine2Label;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;

- (void)editProfile;
- (void)refresh;
- (void)updateDataWithUserDictionary;

@end
