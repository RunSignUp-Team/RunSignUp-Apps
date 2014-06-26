//
//  RaceSignUpMembershipsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/9/14.
//
//

#import <UIKit/UIKit.h>
#import "RaceSignUpMembershipsTableViewCell.h"

@interface RaceSignUpMembershipsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RaceSignUpMembershipsTableViewCellDelegate>{
    NSMutableDictionary *dataDict;
    UITableView *table;
    
    UITextField *currentTextField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;

- (IBAction)chooseMemberships:(id)sender;

@end
