//
//  SignInViewController.m
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
        NSLog(@"Ac: %@ Data: %@", [keychain objectForKey: kSecAttrAccount], [keychain objectForKey: kSecValueData]);

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:[[UIScreen mainScreen] bounds].size.width / 2 - 80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview: rli];
    [rli release];

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
    
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [emailField setFont: [UIFont fontWithName:@"OpenSans" size:14]];
    [passField setFont: [UIFont fontWithName:@"OpenSans" size:14]];

    [[signInButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:18]];
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass: [UILabel class]])
            [(UILabel *)view setFont: [UIFont fontWithName:@"OpenSans" size:18]];
    }
    
    // Set email field to have keyboard open on load
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] boolValue]){
        NSString *email = [keychain objectForKey: kSecAttrAccount];
        NSString *pass = [keychain objectForKey: kSecValueData];

        if(email && pass && [email length] && [pass length]){
            [emailField setText: [keychain objectForKey: kSecAttrAccount]];
            [passField setText: [keychain objectForKey: kSecValueData]];
            [rememberSwitch setOn: YES];
            [passField becomeFirstResponder];
        }else{
            [emailField becomeFirstResponder];
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
                    if([rememberSwitch isOn]){
                        [keychain setObject:[emailField text] forKey:kSecAttrAccount];
                        [keychain setObject:[passField text] forKey:kSecValueData];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool: YES] forKey:@"RememberMe"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RememberMe"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
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
