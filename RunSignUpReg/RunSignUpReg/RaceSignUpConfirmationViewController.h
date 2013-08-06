//
//  RaceSignUpConfirmationViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/6/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpConfirmationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UILabel *raceNameLabel;
    UILabel *registeredLabel;
    
    UITableView *eventsTable;
    
    UIView *registrantView;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *dobLabel;
    UILabel *genderLabel;
    UILabel *phoneLabel;
    UILabel *addressLabel;
    UILabel *tshirtLabel;
    
    UILabel *totalLabel;
    
    UIView *otherView;
    UIView *totalView;
    UIScrollView *scrollView;
    
    UIButton *mistakeButton;
    UIButton *mainMenuButton;
    
    NSMutableDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UILabel *raceNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *registeredLabel;
@property (nonatomic, retain) IBOutlet UITableView *eventsTable;

@property (nonatomic, retain) IBOutlet UIView *registrantView;
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

@property (nonatomic, retain) IBOutlet UILabel *totalLabel;

@property (nonatomic, retain) IBOutlet UIView *otherView;
@property (nonatomic, retain) IBOutlet UIView *totalView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIButton *mistakeButton;
@property (nonatomic, retain) IBOutlet UIButton *mainMenuButton;

- (IBAction)returnToMainMenu:(id)sender;
- (IBAction)clearTransaction:(id)sender;

- (void)printConfirmation;

@end
