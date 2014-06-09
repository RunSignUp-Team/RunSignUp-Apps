//
//  RaceSignUpQuestionsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import <UIKit/UIKit.h>
#import "RaceSignUpQuestionsTableViewCell.h"
#import "RaceSignUpCartTableViewCell.h"

@interface RaceSignUpQuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RaceSignUpQuestionsTableViewCellDelegate>{
    NSMutableDictionary *dataDict;
    
    NSMutableArray *responses;
    
    UITextField *currentTextField;
    UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *responses;

- (IBAction)answerQuestions:(id)sender;
- (void)hideKeyboard;

@end
