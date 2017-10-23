//
//  SecondViewController.m
//  runsignup_mobile
//
//  Created by James Harris on 10/3/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import "SecondViewController.h"
#import "constants.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize mWebView;

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [mWebView setDelegate:self];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on WebView
    [mWebView addGestureRecognizer:swipeLeft];
    [mWebView addGestureRecognizer:swipeRight];
    
    [super viewDidLoad];
    
    UIColor *ombreStart = [UIColor colorWithRed:0.12 green:0.65 blue:0.87 alpha:1.0];
    UIColor *ombreMid = [UIColor colorWithRed:0.29 green:0.78 blue:0.91 alpha:1.0];
    UIColor *ombreEnd = [UIColor colorWithRed:0.27 green:0.83 blue:0.98 alpha:1.0];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.toolbar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[ombreStart CGColor], (id)[ombreMid CGColor], (id)[ombreEnd CGColor], nil];
    
    CGFloat angle = 45.f;
    CGFloat x = angle / 360.f;
    
    CGFloat a = pow(sin((2*M_PI*((x+0.75)/2))),2);
    CGFloat b = pow(sin((2*M_PI*((x+0.0)/2))),2);
    CGFloat c = pow(sin((2*M_PI*((x+0.25)/2))),2);
    CGFloat d = pow(sin((2*M_PI*((x+0.5)/2))),2);
    
    gradient.startPoint = CGPointMake(a, d);
    gradient.endPoint = CGPointMake(c, b);
    [self.navigationController.toolbar.layer insertSublayer:gradient atIndex:0];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setContent
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:RSU_ENTRY_POINT_SERVER_URL]];
    [request addValue:CUSTOM_HEADER_MOBILE_TYPE_FIELDVALUE forHTTPHeaderField:CUSTOM_HEADER_MOBILE_TYPE_FIELDNAME];
    [mWebView loadRequest:request];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self goForward];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self goBack];
    }
}

- (void)goBack {
    if( [mWebView canGoBack] ) {
        [mWebView goBack];
    }
    else {
        // just get back to start page
        [self setContent];
    }
}

- (void)goForward {
    if( [mWebView canGoForward]) {
        [mWebView goForward];
    }
}

#pragma mark - UIWebView Delegate Protocol

// moved header addition to custom URL loading protocol class
//-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)updateButtons
{
    self.forwardButton.enabled = self.mWebView.canGoForward;
    self.backButton.enabled = self.mWebView.canGoBack;
}
@end
