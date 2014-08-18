//
//  RaceShallowDetailsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/28/14.
//
//

#import <UIKit/UIKit.h>

@interface RaceShallowDetailsViewController : UIViewController{
    UIView *allViews;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UILabel *dateLabel;
    UILabel *typeLabel;
    
    UIButton *viewRaceButton;
    UIButton *backButton;
    
    NSDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UIView *allViews;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UIButton *viewRaceButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

- (IBAction)viewRacePage:(id)sender;
- (IBAction)goBack:(id)sender;

@end
