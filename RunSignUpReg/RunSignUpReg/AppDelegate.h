//
//  AppDelegate.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@end