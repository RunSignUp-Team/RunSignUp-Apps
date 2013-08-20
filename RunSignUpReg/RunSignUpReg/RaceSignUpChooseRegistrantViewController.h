//
//  RaceSignUpChooseRegistrantViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface RaceSignUpChooseRegistrantViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SignInViewControllerDelegate, SignUpViewControllerDelegate>{
    UITableView *table;
    
    NSMutableDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
