//
//  RaceResultsEventViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@interface RaceResultsEventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    NSDictionary *dataDict;
    NSArray *results;
    
    RoundedLoadingIndicator *rli;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@end
