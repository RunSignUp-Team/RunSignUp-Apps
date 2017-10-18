//
//  ThirdViewController.m
//  runsignup_mobile
//
//  Created by James Harris on 10/3/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize mWebView;

- (void)viewDidLoad {
    
    mWebView.navigationDelegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *leftColor = [UIColor colorWithRed:0.12 green:0.65 blue:0.87 alpha:1.0];
    UIColor *middleColor = [UIColor colorWithRed:0.29 green:0.78 blue:0.91 alpha:1.0];
    UIColor *rightColor = [UIColor colorWithRed:0.29 green:0.93 blue:0.90 alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)leftColor.CGColor, (id)middleColor.CGColor,(id)rightColor.CGColor, nil];
    theViewGradient.startPoint = CGPointMake(0, 1);
    theViewGradient.endPoint = CGPointMake(1, 0);
    theViewGradient.frame = self.view.bounds;
    //Add gradient to view
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [self setContent];
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    // insure we clear the timers from running
    // in order to insure we are not left with LEFTOVER timers running on the webview... blank it
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    [super viewDidDisappear:animated];
}


-(void)setContent
{
    
}
@end
