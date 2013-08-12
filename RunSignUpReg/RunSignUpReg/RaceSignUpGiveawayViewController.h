//
//  RaceSignUpGiveawayViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpGiveawayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *giveawayTable;
    
    NSMutableDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *giveawayTable;

- (IBAction)chooseGiveaways:(id)sender;

@end
