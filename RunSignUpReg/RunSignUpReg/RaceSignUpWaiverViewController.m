//
//  RaceSignUpWaiverViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpWaiverViewController.h"
#import "RaceSignUpGiveawayViewController.h"
#import "RaceSignUpQuestionsViewController.h"
#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpPaymentViewController.h"

@implementation RaceSignUpWaiverViewController
@synthesize agreeButton;
@synthesize waiverView;
@synthesize waiverLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        self.title = @"Waiver";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [agreeButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [agreeButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    [waiverLabel setFont: [UIFont boldSystemFontOfSize: 11.0f]];
    if([dataDict objectForKey: @"Waiver"] != nil && [(NSString *)[dataDict objectForKey: @"Waiver"] length] > 0)
        [waiverView setText: [dataDict objectForKey: @"Waiver"]];
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        [agreeButton setEnabled: YES];
    }
}*/

- (IBAction)agree:(id)sender{
    BOOL hasGiveaway = NO;
    for(NSDictionary *event in [dataDict objectForKey: @"events"]){
        if([event objectForKey: @"giveaway"] != nil || [event objectForKey: @"giveaway-options"] != nil)
            hasGiveaway = YES;
    }
    
    RaceSignUpWaiverViewController *rswvc = [[RaceSignUpWaiverViewController alloc] initWithNibName:@"RaceSignUpWaiverViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rswvc animated:YES];
    [rswvc release];
    
    if(hasGiveaway){
        RaceSignUpGiveawayViewController *rsugvc = [[RaceSignUpGiveawayViewController alloc] initWithNibName:@"RaceSignUpGiveawayViewController" bundle:nil data:dataDict];
        [self.navigationController pushViewController:rsugvc animated:YES];
        [rsugvc release];
    }else{
        if([dataDict objectForKey: @"membership_settings"]){
            RaceSignUpMembershipsViewController *rsumvc = [[RaceSignUpMembershipsViewController alloc] initWithNibName:@"RaceSignUpMembershipsViewController" bundle:nil data:dataDict];
            [self.navigationController pushViewController:rsumvc animated:YES];
            [rsumvc release];
        }else if([dataDict objectForKey: @"questions"]){
            RaceSignUpQuestionsViewController *rsuqvc = [[RaceSignUpQuestionsViewController alloc] initWithNibName:@"RaceSignUpQuestionsViewController" bundle:nil data:dataDict];
            [self.navigationController pushViewController:rsuqvc animated:YES];
            [rsuqvc release];
        }else{
            RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:dataDict];
            [self.navigationController pushViewController:rsupvc animated:YES];
            [rsupvc release];
        }
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
