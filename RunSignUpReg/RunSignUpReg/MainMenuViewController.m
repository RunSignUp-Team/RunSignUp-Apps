//
//  MainMenuViewController.m
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

#import "MainMenuViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "RaceListViewController.h"
#import "ProfileViewController.h"
#import "UserRaceListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "KeychainItemWrapper.h"

#import "RaceResultsViewController.h"

@implementation MainMenuViewController
@synthesize findRaceButton;
@synthesize signInButton;
@synthesize signUpButton;
@synthesize signOutButton;
@synthesize viewProfileButton;

@synthesize settingsLabel;

@synthesize signedInAsLabel;
@synthesize emailLabel;
@synthesize copyrightLabel;

@synthesize hintPageControl;
@synthesize hintScrollView;

@synthesize backgroundView;
@synthesize titleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        signedIn = NO;
        firstLoad = YES;
        hintPageControlIsChangingPage = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        
        // iOS 7 Parallax effect:
        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        interpolationHorizontal.minimumRelativeValue = @-12;
        interpolationHorizontal.maximumRelativeValue = @12;
        
        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        interpolationVertical.minimumRelativeValue = @-12;
        interpolationVertical.maximumRelativeValue = @12;
        
        [self.backgroundView addMotionEffect:interpolationHorizontal];
        [self.backgroundView addMotionEffect:interpolationVertical];
        
        UIInterpolatingMotionEffect *buttonsInterpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        buttonsInterpolationHorizontal.minimumRelativeValue = @-20;
        buttonsInterpolationHorizontal.maximumRelativeValue = @20;
        
        UIInterpolatingMotionEffect *buttonsInterpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        buttonsInterpolationVertical.minimumRelativeValue = @-20;
        buttonsInterpolationVertical.maximumRelativeValue = @20;
        
        UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
        [effectGroup setMotionEffects: @[buttonsInterpolationHorizontal, buttonsInterpolationVertical]];
        
        for(UIView *view in [self.view subviews]){
            if(view != backgroundView)
                [view addMotionEffect: effectGroup];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoSignIn"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] != nil){
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"RSURegLogin" accessGroup:nil];
        NSString *email = [keychain objectForKey: kSecAttrAccount];
        NSString *pass = [keychain objectForKey: kSecValueData];
        
        if(email && pass && [email length] > 0 && [pass length] > 0){
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUSuccess){
                    [self didSignInEmail: email];
                }
            };
            [[RSUModel sharedModel] loginWithEmail:email pass:pass response:response];
        }
    }
    
    
    // Reverse signup button's image
    /*UIImage *originalImage = [signUpButton backgroundImageForState: UIControlStateNormal];
    [signUpButton setBackgroundImage:[UIImage imageWithCGImage:originalImage.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored] forState:UIControlStateNormal];*/
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    UIImage *orangeButtonImage = [UIImage imageNamed:@"OrangeButtonFilled.png"];
    UIImage *stretchedOrangeButton = [orangeButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *whiteButtonImage = [UIImage imageNamed:@"WhiteButtonFilled.png"];
    UIImage *stretchedWhiteButton = [whiteButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];


    [findRaceButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    //[findRaceButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    //[signOutButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [viewProfileButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    //[viewProfileButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signUpButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    
    for(UIButton *button in @[findRaceButton, signOutButton, viewProfileButton, signInButton, signUpButton]){
        [[button titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:20]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass: [UILabel class]]){
            [(UILabel *)view setFont: [UIFont fontWithName:@"OpenSans" size:[[(UILabel *)view font] pointSize]]];
        }
    }
    
    // Date formatter set up to allow future-proof Copyright tag on bottom of main menu.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignUp, LLC", [formatter stringFromDate: date]]];
    [formatter release];
    
    NSMutableArray *hintArray = [[NSMutableArray alloc] initWithObjects:@"You can search for races by location. Try finding ones near you!",
                          @"Many races have a free giveaway such as a T-Shirt.",
                          @"Tap \"Remind Me\" on the race details page to set up a calendar event to alert you.",
                          @"You can print the race registration confirmation if you have an AirPrint enabled printer nearby.",
                          @"You can pan and zoom the map preview on the race details page.",
                          @"RunSignUp also offers \"RunSignUp Mobile Timer\" for race directors.",
                          @"Pull down from the top of the page to refresh the race list.", nil];
    
    srand(time(NULL)); // seed random
    for(NSUInteger shuffleIndex = [hintArray count] - 1; shuffleIndex > 0; shuffleIndex--)
            [hintArray exchangeObjectAtIndex:shuffleIndex withObjectAtIndex:rand() % (shuffleIndex + 1)];
    
    [hintScrollView setCanCancelContentTouches: NO];
    [hintScrollView setClipsToBounds: YES];
    
    for (int x = 0; x < [hintArray count]; x++){
		UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(x * 320 + 20, 10, 280, hintScrollView.frame.size.height - 20)];
        [label setLineBreakMode: NSLineBreakByWordWrapping];
        [label setNumberOfLines: 0];
        [label setFont: [UIFont fontWithName:@"OpenSans" size:22]];
        [label setText: [hintArray objectAtIndex: x]];
        [label setTextColor: [UIColor whiteColor]];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextAlignment: NSTextAlignmentCenter];
        /*[label.layer setBorderColor: [UIColor blackColor].CGColor];
        [label.layer setBorderWidth: 1.0f];*/
        [label.layer setShadowColor: [UIColor blackColor].CGColor];
        [label.layer setShadowRadius: 4.0f];
        [label.layer setShadowOpacity: 1.0f];
        [label.layer setShadowOffset: CGSizeZero];
        [label.layer setMasksToBounds: NO];
        
		[hintScrollView addSubview: label];
    }
    
    for(UIView *view in [self.view subviews]){
        if([view isKindOfClass: [UILabel class]] || [view isKindOfClass: [UITextView class]]){
            [view.layer setShadowColor: [UIColor blackColor].CGColor];
            [view.layer setShadowRadius: 4.0f];
            [view.layer setShadowOpacity: 1.0f];
            [view.layer setShadowOffset: CGSizeZero];
            [view.layer setMasksToBounds: NO];
        }
    }
    
    [hintPageControl setNumberOfPages: [hintArray count]];
    [hintScrollView setContentSize: CGSizeMake(320 * [hintArray count], hintScrollView.frame.size.height)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (hintPageControlIsChangingPage) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    hintPageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    hintPageControlIsChangingPage = NO;
}

/*- (IBAction)changePage:(id)sender{
    CGRect frame = hintScrollView.frame;
    frame.origin.x = frame.size.width * hintPageControl.currentPage;
    frame.origin.y = 0;
	
    [hintScrollView scrollRectToVisible:frame animated:YES];
    hintPageControlIsChangingPage = YES;
}*/

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
        [hintScrollView setHidden: YES];
        [hintPageControl setHidden: YES];
        signedIn = YES;
    }else if(![[RSUModel sharedModel] signedIn] && signedIn){
        [emailLabel setHidden: YES];
        [signedInAsLabel setHidden: YES];
        [findRaceButton setHidden: NO];
        [signOutButton setHidden: YES];
        [signUpButton setHidden: NO];
        [signInButton setHidden: NO];
        [viewProfileButton setHidden: YES];
        [hintScrollView setHidden: NO];
        [hintPageControl setHidden: NO];
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
    [hintScrollView setHidden: YES];
    [hintPageControl setHidden: YES];
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
    [hintScrollView setHidden: NO];
    [hintPageControl setHidden: NO];
    signedIn = NO;
    [[RSUModel sharedModel] logout];
}

- (IBAction)signUp:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://runsignup.com/CreateAccount"]];
    
    /*SignUpViewController *svc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [svc setSignUpMode: RSUSignUpDefault];
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];*/
}

/*- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://runsignup.com/CreateAccount"]];
    }
}*/

- (IBAction)settings:(id)sender{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:billy_connolly@comcast.net?cc=info@runsignup.com&subject=Bug%20Report"]];
    SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self presentViewController:svc animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
