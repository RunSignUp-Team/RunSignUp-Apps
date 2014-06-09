//
//  RaceSignUpMembershipsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/9/14.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpMembershipsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableDictionary *dataDict;
    UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
