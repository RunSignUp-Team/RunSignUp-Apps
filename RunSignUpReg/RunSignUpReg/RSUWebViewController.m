//
//  RSUWebViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/28/14.
//
//

#import "RSUWebViewController.h"

@implementation RSUWebViewController
@synthesize webView;
@synthesize historyBackButton;
@synthesize historyForwardButton;
@synthesize titleLabel;
@synthesize urlLabel;
@synthesize topToolbar;
@synthesize bottomToolbar;

- (id)initWithURL:(NSURL *)url{
    self = [super initWithNibName:@"RSUWebViewController" bundle:nil];
    if(self){
        urlToLoad = url;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        for(UIView *subView in [self.view subviews]){
            CGRect frame = [subView frame];
            frame.origin.y += 20;
            [subView setFrame: frame];
        }
        CGRect webFrame = webView.frame;
        webFrame.size.height = [self.view bounds].size.height - bottomToolbar.frame.size.height - webFrame.origin.y;
        [webView setFrame: webFrame];
        
        CGRect frame = bottomToolbar.frame;
        frame.origin.y = [self.view bounds].size.height - bottomToolbar.frame.size.height;
        [bottomToolbar setFrame: frame];        
    }
        
    NSURLRequest *request = [NSURLRequest requestWithURL: urlToLoad];
    [webView loadRequest: request];
}

- (IBAction)historyBack:(id)sender{
    [webView goBack];
}

- (IBAction)historyForward:(id)sender{
    [webView goForward];
}

- (IBAction)refresh:(id)sender{
    [webView reload];
}

- (void)updateButtons{
    [historyForwardButton setEnabled: [webView canGoForward]];
    [historyBackButton setEnabled: [webView canGoBack]];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    if(bar == topToolbar)
        return UIBarPositionTopAttached;
    else
        return UIBarPositionBottom;
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [urlLabel setText: [request.URL absoluteString]];
    
    [self updateButtons];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [titleLabel setText: @"Loading..."];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv{
    NSURL *currentURL = [webView request].URL;
    [titleLabel setText: [webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    [urlLabel setText: [currentURL absoluteString]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

    [self updateButtons];
}

- (IBAction)goBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showActions:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy Link", @"Open in Safari", nil];
    [sheet showInView: self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: [webView.request.URL absoluteString]];
    }else if(buttonIndex == 1){
        NSURL *currentURL = webView.request.URL;
        [[UIApplication sharedApplication] openURL: currentURL];
    }
}

- (void)dealloc{
    // Recommended in apple docs to set delgate to nil before releasing a webview
    webView.delegate = nil;
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
