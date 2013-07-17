//
//  UserRaceListViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 10/29/12.
//
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@interface UserRaceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *table;
    NSArray *raceList;

    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;


@end
