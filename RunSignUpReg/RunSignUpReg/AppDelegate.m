//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "VTClient.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize navController;

- (void)dealloc{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"AutoSignIn"] == nil){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoSignIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    }else{
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"OpenSans" size:16]];
    [[UILabel appearanceWhenContainedIn:[UIPickerView class], nil] setFont:[UIFont fontWithName:@"OpenSans" size:20]];

    //[[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:@"OpenSans" size:18], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
    
    //[[UILabel appearance] setFont: [UIFont fontWithName:@"OpenSans" size:18.0f]];
    //[[UILabel appearanceWhenContainedIn: [UIButton class], nil] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:20.0f]];
    
    NSDictionary *navigationBarButtonAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f],
                                                    NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:18]
                                                    };
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:navigationBarButtonAttributes forState:UIControlStateNormal];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    MainMenuViewController *mmvc = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController: mmvc];
    [[navController navigationBar] setTranslucent: NO];
    //[[navController navigationBar] setBackgroundColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
    //[[navController navigationBar] setTintColor: [UIColor whiteColor]];
    //[[navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"OpenSans" size:0.0], NSFontAttributeName, nil]];
    [self.window setRootViewController: navController];
    [mmvc release];
    [navController release];
    [self.window makeKeyAndVisible];
    //[self initVTClient];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
