//
//  FirstViewController.m
//  runsignup_mobile
//
//  Created by James Harris on 10/3/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import "FirstViewController.h"
#import "constants.h"

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
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:RSU_ENTRY_POINT_SERVER_URL]];
    [request addValue:CUSTOM_HEADER_MOBILE_TYPE_FIELDVALUE forHTTPHeaderField:CUSTOM_HEADER_MOBILE_TYPE_FIELDNAME];
    [mWebView loadRequest:request];
    mWebView.allowsBackForwardNavigationGestures = YES;
}
@end
