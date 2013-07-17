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
    UIButton *signOutButton;
    
    BOOL signedIn;
    
    UILabel *notRegisteredYetLabel;
    UILabel *signUpLabel;
    UIView *signUpUnderline;
    UILabel *aboutLabel;
    UILabel *settingsLabel;
    
    UILabel *signedInAsLabel;
    UILabel *emailLabel;
    
    UILabel *raceDirectorsOnlyLabel;
    UIButton *raceListButton;
    
    UILabel *copyrightLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *findRaceButton;
@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIButton *signOutButton;

@property (nonatomic, retain) IBOutlet UILabel *notRegisteredYetLabel;
@property (nonatomic, retain) IBOutlet UILabel *signUpLabel;
@property (nonatomic, retain) IBOutlet UIView *signUpUnderline;
@property (nonatomic, retain) IBOutlet UILabel *aboutLabel;
@property (nonatomic, retain) IBOutlet UILabel *settingsLabel;

@property (nonatomic, retain) IBOutlet UILabel *signedInAsLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;

@property (nonatomic, retain) IBOutlet UILabel *raceDirectorsOnlyLabel;
@property (nonatomic, retain) IBOutlet UIButton *raceListButton;

- (IBAction)signUp:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)findRace:(id)sender;
- (IBAction)raceList:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)signOut:(id)sender;

- (void)didSignInEmail:(NSString *)email;

@end
