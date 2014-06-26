//
//  SettingsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/16/14.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    UISwitch *autoSignInSwitch;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UISwitch *autoSignInSwitch;

- (IBAction)autoSignInChange:(id)sender;
- (IBAction)done:(id)sender;

@end
