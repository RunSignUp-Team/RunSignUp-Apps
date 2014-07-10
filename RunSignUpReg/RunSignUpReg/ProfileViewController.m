//
//  ProfileViewController.m
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

#import "ProfileViewController.h"
#import "RSUModel.h"

@implementation ProfileViewController
@synthesize nameLabel;
@synthesize propicLabel;

@synthesize userDictionary;
@synthesize isUserProfile;

@synthesize rli;

@synthesize emailLabel;
@synthesize addressLine1Label;
@synthesize addressLine2Label;
@synthesize phoneLabel;
@synthesize genderLabel;
@synthesize dobLabel;
@synthesize profileImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isUserProfile:(BOOL)iup{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isUserProfile = iup;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        
        [[rli label] setText:@"Loading..."];
        
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview: rli];
    [rli release];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    if(isUserProfile){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile)];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editButton, refreshButton, nil]];
    }
}

- (void)didSignUpWithDictionary:(NSDictionary *)dict{
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refresh];
}

- (void)updateDataWithUserDictionary{
    if(userDictionary){
        NSLog(@"%@", userDictionary);
        [nameLabel setText: [NSString stringWithFormat:@"%@ %@", [userDictionary objectForKey:@"first_name"], [userDictionary objectForKey:@"last_name"]]];
        [emailLabel setText: [userDictionary objectForKey: @"email"]];
        [addressLine1Label setText: [[userDictionary objectForKey: @"address"] objectForKey:@"street"]];
        NSString *addressLine2 = [NSString stringWithFormat:@"%@, %@ %@ %@", [[userDictionary objectForKey: @"address"] objectForKey:@"city"], [[userDictionary objectForKey: @"address"] objectForKey:@"state"], [[userDictionary objectForKey: @"address"] objectForKey:@"country_code"], [[userDictionary objectForKey: @"address"] objectForKey:@"zipcode"]];
        [addressLine2Label setText: addressLine2];
        [phoneLabel setText: [userDictionary objectForKey: @"phone"]];
        if([[userDictionary objectForKey:@"gender"] isEqualToString:@"F"]){
            [genderLabel setText: @"Female"];
        }else{
            [genderLabel setText: @"Male"];
        }
        [dobLabel setText: [userDictionary objectForKey: @"dob"]];
        
        if([userDictionary objectForKey:@"profile_image_url"]){
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http:%@", [userDictionary objectForKey:@"profile_image_url"]]]];
                if(imageData == nil)
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [profileImageView setImage: [UIImage imageWithData: imageData]];
                });
                [imageData release];
            });
        }
    }
}

- (void)editProfile{
    SignUpViewController *svc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [svc setProfileViewController: self];
    [svc setSignUpMode: RSUSignUpEditingUser];
    [svc setUserDictionary: userDictionary];
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
}

- (void)refresh{
    [rli fadeIn];
    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
        if(didSucceed == RSUSuccess){
            [rli fadeOut];
            self.userDictionary = [[NSDictionary alloc] initWithDictionary:[[RSUModel sharedModel] currentUser] copyItems:YES];
            [self updateDataWithUserDictionary];
        }
    };
    
    [[RSUModel sharedModel] retrieveUserInfo:response];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
