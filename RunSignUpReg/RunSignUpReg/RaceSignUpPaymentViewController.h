//
//  RaceSignUpPaymentViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceSignUpPaymentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    NSDictionary *dataDict;
    
    UITableView *registrantsTable;
    UILabel *registrationCartHintLabel;
    UITableView *registrationCartTable;
    
    UILabel *baseCostHintLabel;
    UILabel *baseCostLabel;
    UILabel *processingFeeHintLabel;
    UILabel *processingFeeLabel;
    UILabel *totalHintLabel;
    UILabel *totalLabel;
    
    UITextField *couponField;
    UILabel *couponHintLabel;
    UIButton *applyButton;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView  *registrantsTable;
@property (nonatomic, retain) IBOutlet UILabel *registrationCartHintLabel;
@property (nonatomic, retain) IBOutlet UITableView  *registrationCartTable;
@property (nonatomic, retain) IBOutlet UILabel *baseCostHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *baseCostLabel;
@property (nonatomic, retain) IBOutlet UILabel *processingFeeHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *processingFeeLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UITextField *couponField;
@property (nonatomic, retain) IBOutlet UILabel *couponHintLabel;
@property (nonatomic, retain) IBOutlet UIButton *applyButton;

- (IBAction)applyCoupon:(id)sender;

- (void)layoutContent;

@end
