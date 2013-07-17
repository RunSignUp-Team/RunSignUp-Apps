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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
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
        [self setEdgesForExtendedLayout: UIExtendedEdgeNone];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [agreeButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [agreeButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
}

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
