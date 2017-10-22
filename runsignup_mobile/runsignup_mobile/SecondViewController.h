//
//  SecondViewController.h
//  runsignup_mobile
//
//  Created by James Harris on 10/3/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SecondViewController : UIViewController <UIWebViewDelegate>

//@property (weak, nonatomic) IBOutlet WKWebView *mWebView;
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@end

