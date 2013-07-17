//
//  ProfileViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "RSUModel.h"

@implementation ProfileViewController
@synthesize nameLabel;
@synthesize propicLabel;

@synthesize userDictionary;
@synthesize isUserProfile;

@synthesize emailLabel;
@synthesize addressLine1Label;
@synthesize addressLine2Label;
@synthesize phoneLabel;
@synthesize genderLabel;
@synthesize dobLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if([[RSUModel sharedModel] lastParsedUser] != nil){
            self.userDictionary = [[NSDictionary alloc] initWithDictionary:[[RSUModel sharedModel] lastParsedUser] copyItems:YES];
        }
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIExtendedEdgeNone];
    
    [self updateDataWithUserDictionary];
    
    if(isUserProfile){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile)];
        [self.navigationItem setRightBarButtonItem: editButton];
    }    
}

- (void)updateDataWithUserDictionary{
    if(userDictionary){
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
    }
}

- (void)editProfile{
    SignUpViewController *svc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil profileViewController: self];
    [svc setIsEditingUserProfile: YES];
    [svc setUserDictionary: userDictionary];
    [svc setTitle:@"Edit Profile"];
    [self.navigationController pushViewController:svc animated:YES];
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
