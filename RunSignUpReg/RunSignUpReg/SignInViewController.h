//
//  SignInViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"
#import "KeychainItemWrapper.h"

@protocol SignInViewControllerDelegate <NSObject>
- (void)didSignInEmail:(NSString *)email;
@end

@interface SignInViewController : UIViewController <UITextFieldDelegate>{
    UIButton *signInButton;
    UITextField *emailField;
    UITextField *passField;
    
    KeychainItemWrapper *keychain;
    
    UISwitch *rememberSwitch;
    
    UIViewController<SignInViewControllerDelegate> *delegate;
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) UIViewController<SignInViewControllerDelegate> *delegate;

@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passField;
@property (nonatomic, retain) IBOutlet UISwitch *rememberSwitch;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (IBAction)signIn:(id)sender;
- (IBAction)cancel:(id)sender;

@end