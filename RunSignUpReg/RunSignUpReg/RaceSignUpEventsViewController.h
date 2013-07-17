//
//  RaceSignUpEventsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpEventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *eventsTable;
    
    NSDictionary *dataDict;
    NSMutableArray *selectedArray;
        
    UIButton *selectButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *eventsTable;
@property (nonatomic, retain) IBOutlet UIButton *selectButton;

@end
