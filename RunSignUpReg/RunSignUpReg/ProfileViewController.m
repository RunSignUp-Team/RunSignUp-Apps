//
//  ProfileViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
        [self.view addSubview: rli];
        [rli release];
        
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
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
        [nameLabel setText: [NSString stringWithFormat:@"%@ %@", [userDictionary objectForKey:@"FName"], [userDictionary objectForKey:@"LName"]]];
        [emailLabel setText: [userDictionary objectForKey: @"Email"]];
        [addressLine1Label setText: [userDictionary objectForKey: @"Street"]];
        NSString *addressLine2 = [NSString stringWithFormat:@"%@, %@ %@ %@", [userDictionary objectForKey: @"City"], [userDictionary objectForKey: @"State"], [userDictionary objectForKey: @"Country"], [userDictionary objectForKey: @"Zipcode"]];
        [addressLine2Label setText: addressLine2];
        [phoneLabel setText: [userDictionary objectForKey: @"Phone"]];
        if([[userDictionary objectForKey:@"Gender"] isEqualToString:@"F"]){
            [genderLabel setText: @"Female"];
        }else{
            [genderLabel setText: @"Male"];
        }
        [dobLabel setText: [userDictionary objectForKey: @"DOB"]];
        
        if([userDictionary objectForKey:@"ProfileImage"]){
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"http:%@", [userDictionary objectForKey:@"ProfileImage"]]]];
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
