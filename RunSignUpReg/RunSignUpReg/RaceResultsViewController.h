//
//  RaceResultsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
