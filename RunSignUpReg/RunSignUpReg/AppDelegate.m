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
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    MainMenuViewController *mmvc = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController: mmvc];
    [[navController navigationBar] setTintColor: [UIColor colorWithRed:0.0f green:0.5686f blue:0.7843f alpha:1.0f]];
    [self.window setRootViewController: navController];
    [mmvc release];
    [navController release];
    [self.window makeKeyAndVisible];
    //[self initVTClient];
    return YES;
}

- (void)initVTClient{
    [VTClient startWithMerchantID: @"bm5c2r6249hyq3h5" braintreeClientSideEncryptionKey: @"MIIBCgKCAQEA1HctGOXz5/3OgQuktOtkFbeUQLCU0KvS3gI2zb34JUCFuLtdVjagkgqLMmgqhiuKrMWJdWhJ7kO3mdBO45xQnD4b9/WjgwOMHb4IY6sBlItGKP1t3VnatQSaHULxLFRRrxR1kLB15QVwQD1GibzkiXbhOXqOonqvd4lobqc1t4tQqKEX8smxXegowMtDurnAFGoD15h1FdeTf/4J4d6Jop58Oj7rKaCny6XPV4gS8ygRgqCUfze4R8rMLk4780k42+DGQZh6/2DkrsOUm4et3L9+3e1uaUkvBtoBYFXoOdZuB9o/N+gS6TRbYb328HClbdly/yywlZEbVi5ubhao+wIDAQAB" environment: VTEnvironmentSandbox];
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
