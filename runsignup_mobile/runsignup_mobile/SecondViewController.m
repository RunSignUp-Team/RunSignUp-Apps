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
