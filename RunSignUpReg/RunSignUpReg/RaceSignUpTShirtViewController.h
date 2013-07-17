//
//  RaceSignUpTShirtViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceSignUpTShirtViewController : UIViewController{
    UIButton *selectButton;
    UISegmentedControl *tshirtControl;
    
    NSDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UIButton *selectButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tshirtControl;

- (IBAction)select:(id)sender;

@end
