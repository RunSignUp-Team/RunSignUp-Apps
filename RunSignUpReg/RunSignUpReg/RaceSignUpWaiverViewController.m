//
//  RaceSignUpWaiverViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpWaiverViewController.h"
#import "RaceSignUpEventsViewController.h"

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
    RaceSignUpEventsViewController *rsuevc = [[RaceSignUpEventsViewController alloc] initWithNibName:@"RaceSignUpEventsViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rsuevc animated:YES];
    [rsuevc release];
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
