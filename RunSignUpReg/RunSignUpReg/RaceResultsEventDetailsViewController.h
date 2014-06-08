//
//  RaceResultsEventDetailsViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/1/14.
//
//

#import <UIKit/UIKit.h>

@interface RaceResultsEventDetailsViewController : UIViewController{
    UIScrollView *scrollView;
    NSDictionary *dataDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
