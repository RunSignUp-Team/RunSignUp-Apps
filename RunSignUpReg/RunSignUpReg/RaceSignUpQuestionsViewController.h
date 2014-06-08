//
//  RaceSignUpQuestionsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@interface RaceSignUpQuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableDictionary *dataDict;
    
    UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data;

@property (nonatomic, retain) IBOutlet UITableView *table;

- (IBAction)answerQuestions:(id)sender;

@end
