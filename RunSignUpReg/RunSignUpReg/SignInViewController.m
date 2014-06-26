//
//  SignInViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "RSUModel.h"

@implementation SignInViewController
@synthesize delegate;
@synthesize signInButton;
@synthesize emailField;
@synthesize passField;
@synthesize rememberSwitch;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"RSURegLogin" accessGroup:nil];

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        
        [self.view addSubview: rli];
        [rli release];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        for(UIView *subView in [self.view subviews]){
            CGRect frame = [subView frame];
            frame.origin.y += 20;
            [subView setFrame: frame];
        }
    }
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Set email field to have keyboard open on load
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] != nil){
        [emailField setText: [keychain objectForKey: kSecAttrAccount]];
        [passField setText: [keychain objectForKey: kSecValueData]];
        [rememberSwitch setOn:YES];
        [passField becomeFirstResponder];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoSignIn"]){
            [self performSelector:@selector(signIn:) withObject:nil afterDelay:0.1f];
        }
    }else{
        [emailField becomeFirstResponder];
    }
    
}

// When return is pressed on email -> go to password field. When return is pressed on password -> sign in.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == emailField){
        [emailField resignFirstResponder];
        [passField becomeFirstResponder];
        return NO;
    }else{
        [self signIn: nil];
        return NO;
    }
}

// Sign in, query if email and password are valid
- (IBAction)signIn:(id)sender{
    if([delegate respondsToSelector:@selector(didSignInEmail:)]){
        if([[emailField text] length] > 0 && [[passField text] length] > 0){
            [rli fadeIn];
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUSuccess){
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberEmail"] == nil){
                        if([rememberSwitch isOn]){
                            [[NSUserDefaults standardUserDefaults] setObject:[emailField text] forKey:@"RememberEmail"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }else{
                        if(![rememberSwitch isOn]){
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RememberEmail"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }
                    
                    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                        if(didSucceed == RSUSuccess){
                            [rli fadeOut];
                            [delegate didSignInEmail: [emailField text]];
                            
                            if(![self isBeingPresented] && ![self isBeingDismissed]){
                                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                            }else{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.31f), dispatch_get_main_queue(), ^{
                                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                });
                            }
                                
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                            [rli fadeOut];
                        }
                    };
                    
                    [[RSUModel sharedModel] retrieveUserInfo: response];
                }else if(didSucceed == RSUInvalidEmail){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user exists with that email address. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else if(didSucceed == RSUInvalidPassword){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The password is invalid. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }
            };
            
            [[RSUModel sharedModel] loginWithEmail:[emailField text] pass:[passField text] response:response];
        }
    }
}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
