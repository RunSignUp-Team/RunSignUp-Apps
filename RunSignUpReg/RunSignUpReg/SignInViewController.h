//
//  SignInViewController.h
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