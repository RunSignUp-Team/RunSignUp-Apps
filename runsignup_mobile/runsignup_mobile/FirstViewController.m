//
//  FirstViewController.m
//  runsignup_mobile
//
//  Created by James Harris on 10/3/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize mWebView;

- (void)viewDidLoad {
    
    mWebView.navigationDelegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://runsignup.com/Profile"]]];
    mWebView.allowsBackForwardNavigationGestures = YES;
}
@end
