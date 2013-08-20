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
@synthesize signUpButton;
@synthesize signOutButton;
@synthesize viewProfileButton;

@synthesize aboutLabel;
@synthesize settingsLabel;

@synthesize signedInAsLabel;
@synthesize emailLabel;
@synthesize copyrightLabel;

@synthesize backgroundView;
@synthesize titleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        signedIn = NO;
        firstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        interpolationHorizontal.minimumRelativeValue = @-15.0;
        interpolationHorizontal.maximumRelativeValue = @15.0;
        
        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        interpolationVertical.minimumRelativeValue = @-15.0;
        interpolationVertical.maximumRelativeValue = @15.0;
        
        [self.backgroundView addMotionEffect:interpolationHorizontal];
        [self.backgroundView addMotionEffect:interpolationVertical];
    }
    
    // Reverse signup button's image
    UIImage *originalImage = [signUpButton backgroundImageForState: UIControlStateNormal];
    [signUpButton setBackgroundImage:[UIImage imageWithCGImage:originalImage.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored] forState:UIControlStateNormal];

    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];

    [findRaceButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [findRaceButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signOutButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [viewProfileButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [viewProfileButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Date formatter set up to allow future-proof Copyright tag on bottom of main menu.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignUp, LLC", [formatter stringFromDate: date]]];
    [formatter release];
        
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:!firstLoad];
    firstLoad = NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if([[RSUModel sharedModel] signedIn] && !signedIn){
        [emailLabel setHidden: NO];
        [emailLabel setText: [[RSUModel sharedModel] email]];
        [signedInAsLabel setHidden: NO];
        [findRaceButton setHidden: NO];
        [signOutButton setHidden: NO];
        [signUpButton setHidden: YES];
        [signInButton setHidden: YES];
        [viewProfileButton setHidden: NO];
        signedIn = YES;
    }else if(![[RSUModel sharedModel] signedIn] && signedIn){
        [emailLabel setHidden: YES];
        [signedInAsLabel setHidden: YES];
        [findRaceButton setHidden: NO];
        [signOutButton setHidden: YES];
        [signUpButton setHidden: NO];
        [signInButton setHidden: NO];
        [viewProfileButton setHidden: YES];
        signedIn = NO;
    }
}

- (void)didSignInEmail:(NSString *)email{
    [emailLabel setHidden: NO];
    [emailLabel setText: email];
    [signedInAsLabel setHidden: NO];
    [findRaceButton setHidden: NO];
    [signOutButton setHidden: NO];
    [signUpButton setHidden: YES];
    [signInButton setHidden: YES];
    [viewProfileButton setHidden: NO];
    signedIn = YES;
}

- (IBAction)findRace:(id)sender{
    RaceListViewController *rlvc = [[RaceListViewController alloc] initWithNibName:@"RaceListViewController" bundle:nil];
    [self.navigationController pushViewController:rlvc animated:YES];
    [rlvc release];
}

- (IBAction)viewProfile:(id)sender{
    if(signedIn){
        ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil isUserProfile:YES];
        [self.navigationController pushViewController:pvc animated:YES];
        [pvc release];
    }
}
// Sign in button also doubles as "view profile" button
- (IBAction)signIn:(id)sender{
    if(!signedIn){
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
    [signUpButton setHidden: NO];
    [signInButton setHidden: NO];
    [viewProfileButton setHidden: YES];
    signedIn = NO;
    [[RSUModel sharedModel] logout];
}

- (IBAction)signUp:(id)sender{
    SignUpViewController *svc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [svc setSignUpMode: RSUSignUpDefault];
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
