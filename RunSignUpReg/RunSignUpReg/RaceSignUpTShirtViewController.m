//
//  RaceSignUpTShirtViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpTShirtViewController.h"
#import "RaceSignUpPaymentViewController.h"

@implementation RaceSignUpTShirtViewController
@synthesize selectButton;
@synthesize tshirtControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        
        self.title = @"T-Shirt";
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
    
    [selectButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [selectButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
}

- (IBAction)select:(id)sender{
    RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rsupvc animated:YES];
    [rsupvc release];
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
