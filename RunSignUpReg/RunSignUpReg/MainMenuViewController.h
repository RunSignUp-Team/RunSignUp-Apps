//
//  MainMenuViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSUModel.h"
#import "SignInViewController.h"

@interface MainMenuViewController : UIViewController <SignInViewControllerDelegate>{
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

@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *titleView;

- (IBAction)viewProfile:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)findRace:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)signOut:(id)sender;

- (void)didSignInEmail:(NSString *)email;

@end
