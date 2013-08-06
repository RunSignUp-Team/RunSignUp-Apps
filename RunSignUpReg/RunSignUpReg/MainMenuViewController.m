//
//  MainMenuViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "RaceListViewController.h"
#import "ProfileViewController.h"
#import "AboutViewController.h"
#import "UserRaceListViewController.h"

#import "RaceResultsViewController.h"

@implementation MainMenuViewController
@synthesize findRaceButton;
@synthesize signInButton;
@synthesize signOutButton;

@synthesize notRegisteredYetLabel;
@synthesize signUpLabel;
@synthesize signUpUnderline;
@synthesize aboutLabel;
@synthesize settingsLabel;

@synthesize signedInAsLabel;
@synthesize emailLabel;
@synthesize copyrightLabel;

@synthesize raceDirectorsOnlyLabel;
@synthesize raceListButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Logo.png"]];
            [self.navigationItem setTitleView: titleView];
        }else{
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Title.png"]];
            [self.navigationItem setTitleView: titleView];
        }
        
        signedIn = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    [findRaceButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [findRaceButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signOutButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [raceListButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [raceListButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Date formatter set up to allow future-proof Copyright tag on bottom of main menu.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignUp, LLC", [formatter stringFromDate: date]]];
    [formatter release];
        
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([[RSUModel sharedModel] signedIn] && !signedIn){
        [emailLabel setHidden: NO];
        [emailLabel setText: [[RSUModel sharedModel] email]];
        [signedInAsLabel setHidden: NO];
        [findRaceButton setHidden: NO];
        [signOutButton setHidden: NO];
        [signInButton setTitle:@"Your Profile" forState:UIControlStateNormal];
        [notRegisteredYetLabel setHidden: YES];
        [signUpLabel setHidden: YES];
        [signUpUnderline setHidden: YES];
        [raceDirectorsOnlyLabel setHidden: NO];
        [raceListButton setHidden: NO];
        signedIn = YES;
    }else if(![[RSUModel sharedModel] signedIn] && signedIn){
        [emailLabel setHidden: YES];
        [signedInAsLabel setHidden: YES];
        [findRaceButton setHidden: NO];
        [signOutButton setHidden: YES];
        [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [notRegisteredYetLabel setHidden: NO];
        [signUpLabel setHidden: NO];
        [signUpUnderline setHidden: NO];
        [raceDirectorsOnlyLabel setHidden: YES];
        [raceListButton setHidden: YES];
        signedIn = NO;
    }
}

- (void)didSignInEmail:(NSString *)email{
    [emailLabel setHidden: NO];
    [emailLabel setText: email];
    [signedInAsLabel setHidden: NO];
    [findRaceButton setHidden: NO];
    [signOutButton setHidden: NO];
    [signInButton setTitle:@"Your Profile" forState:UIControlStateNormal];
    [notRegisteredYetLabel setHidden: YES];
    [signUpLabel setHidden: YES];
    [signUpUnderline setHidden: YES];
    [raceDirectorsOnlyLabel setHidden: NO];
    [raceListButton setHidden: NO];
    signedIn = YES;
}

- (IBAction)findRace:(id)sender{
    RaceListViewController *rlvc = [[RaceListViewController alloc] initWithNibName:@"RaceListViewController" bundle:nil];
    [self.navigationController pushViewController:rlvc animated:YES];
    [rlvc release];
}

- (IBAction)raceList:(id)sender{
    UserRaceListViewController *urlvc = [[UserRaceListViewController alloc] initWithNibName:@"UserRaceListViewController" bundle:nil];
    [self.navigationController pushViewController:urlvc animated:YES];
    [urlvc release];
}

// Sign in button also doubles as "view profile" button
- (IBAction)signIn:(id)sender{
    if(signedIn){
        ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil isUserProfile:YES];
        [self.navigationController pushViewController:pvc animated:YES];
        [pvc release];
    }else{
        SignInViewController *svc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        [svc setDelegate: self];
        [self presentViewController:svc animated:YES completion:nil];
        [svc release];
    }
}

- (IBAction)signOut:(id)sender{
    [emailLabel setHidden: YES];
    [signedInAsLabel setHidden: YES];
    [findRaceButton setHidden: NO];
    [signOutButton setHidden: YES];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [notRegisteredYetLabel setHidden: NO];
    [signUpLabel setHidden: NO];
    [signUpUnderline setHidden: NO];
    [raceDirectorsOnlyLabel setHidden: YES];
    [raceListButton setHidden: YES];
    signedIn = NO;
    [[RSUModel sharedModel] logout];
}

- (IBAction)signUp:(id)sender{
    SignUpViewController *svc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil profileViewController:nil];
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
}

- (IBAction)about:(id)sender{
    AboutViewController *avc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self presentViewController:avc animated:YES completion:nil];
    [avc release];
}

- (IBAction)settings:(id)sender{
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
