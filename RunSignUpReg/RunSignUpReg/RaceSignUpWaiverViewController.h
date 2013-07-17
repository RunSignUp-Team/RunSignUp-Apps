//
//  RaceSignUpWaiverViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceSignUpWaiverViewController : UIViewController{
    UIButton *agreeButton;
    
    NSDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UIButton *agreeButton;

- (IBAction)agree:(id)sender;

@end
