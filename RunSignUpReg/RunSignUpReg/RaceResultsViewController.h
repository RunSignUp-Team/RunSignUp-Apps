//
//  RaceResultsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@interface RaceResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    NSDictionary *dataDict;
    
    NSMutableArray *events;
    
    int retrieveCalls;
    
    RoundedLoadingIndicator *rli;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDictionary *dataDict;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@end
