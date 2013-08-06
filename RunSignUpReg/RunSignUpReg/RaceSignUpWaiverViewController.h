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
    UILabel *waiverLabel;
    
    UITextView *waiverView;
    
    NSMutableDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UIButton *agreeButton;
@property (nonatomic, retain) IBOutlet UITextView *waiverView;
@property (nonatomic, retain) IBOutlet UILabel *waiverLabel;

- (IBAction)agree:(id)sender;

@end
