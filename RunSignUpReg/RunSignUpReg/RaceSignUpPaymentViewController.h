//
//  RaceSignUpPaymentViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@interface RaceSignUpPaymentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSMutableDictionary *dataDict;
    NSDictionary *cartDict;
    
    UILabel *raceNameLabel;
    
    UITableView *eventsTable;
    UITableView *cartTable;
    
    UIView *registrationCartView;
    UIView *couponView;
    UIView *registrantView;
    
    UIScrollView *scrollView;
    
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *dobLabel;
    UILabel *genderLabel;
    UILabel *phoneLabel;
    UILabel *addressLabel;
    UILabel *address2Label;
    
    UILabel *registrationCartHintLabel;
    
    UILabel *baseCostHintLabel;
    UILabel *baseCostLabel;
    UILabel *processingFeeHintLabel;
    UILabel *processingFeeLabel;
    UILabel *totalHintLabel;
    UILabel *totalLabel;
    
    UITextField *couponField;
    UILabel *couponHintLabel;
    UIButton *applyButton;
    
    UILabel *paymentHintLabel;
    UIButton *paymentButton;
    
    BOOL isFreeRace;
    
    RoundedLoadingIndicator *rli;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UILabel *raceNameLabel;

@property (nonatomic, retain) IBOutlet UITableView *eventsTable;
@property (nonatomic, retain) IBOutlet UITableView *cartTable;
@property (nonatomic, retain) IBOutlet UIView *registrationCartView;
@property (nonatomic, retain) IBOutlet UIView *couponView;
@property (nonatomic, retain) IBOutlet UIView *registrantView;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipLabel;
@property (nonatomic, retain) IBOutlet UILabel *tshirtLabel;

@property (nonatomic, retain) IBOutlet UILabel *registrationCartHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *baseCostHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *baseCostLabel;
@property (nonatomic, retain) IBOutlet UILabel *processingFeeHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *processingFeeLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UITextField *couponField;
@property (nonatomic, retain) IBOutlet UILabel *couponHintLabel;
@property (nonatomic, retain) IBOutlet UIButton *applyButton;

@property (nonatomic, retain) IBOutlet UILabel *paymentHintLabel;
@property (nonatomic, retain) IBOutlet UIButton *paymentButton;

@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (IBAction)applyCoupon:(id)sender;
- (IBAction)confirmPayment:(id)sender;
- (void)layoutContent;

@end
