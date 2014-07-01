//
//  MainMenuViewController.h
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
#import "RSUModel.h"
#import "SignInViewController.h"

@interface MainMenuViewController : UIViewController <SignInViewControllerDelegate, UIScrollViewDelegate>{
    UIButton *findRaceButton;
    UIButton *signInButton;
    UIButton *signUpButton;
    UIButton *signOutButton;
    UIButton *viewProfileButton;
    
    BOOL signedIn;
    BOOL firstLoad;
    
    UILabel *aboutLabel;
    UILabel *settingsLabel;
    
    UILabel *signedInAsLabel;
    UILabel *emailLabel;
    
    UILabel *copyrightLabel;
    
    BOOL hintPageControlIsChangingPage;
    UIPageControl *hintPageControl;
    UIScrollView *hintScrollView;
    
    UIImageView *backgroundView;
    UIImageView *titleView;
}

@property (nonatomic, retain) IBOutlet UIButton *findRaceButton;
@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton;
@property (nonatomic, retain) IBOutlet UIButton *signOutButton;
@property (nonatomic, retain) IBOutlet UIButton *viewProfileButton;

@property (nonatomic, retain) IBOutlet UILabel *aboutLabel;
@property (nonatomic, retain) IBOutlet UILabel *settingsLabel;

@property (nonatomic, retain) IBOutlet UILabel *signedInAsLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;

@property (nonatomic, retain) IBOutlet UIPageControl *hintPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *hintScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *titleView;

- (IBAction)viewProfile:(id)sender;
- (IBAction)hideAbout:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)findRace:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)signOut:(id)sender;

- (void)didSignInEmail:(NSString *)email;

@end
