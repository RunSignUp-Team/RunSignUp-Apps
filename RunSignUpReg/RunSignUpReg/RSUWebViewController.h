//
//  RSUWebViewController.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/28/14.
//
//

#import <UIKit/UIKit.h>

@interface RSUWebViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate, UIToolbarDelegate>{
    UIWebView *webView;
    NSURL *urlToLoad;
    
    UILabel *titleLabel;
    UILabel *urlLabel;
    
    UIToolbar *topToolbar;
    UIToolbar *bottomToolbar;
}

- (id)initWithURL:(NSURL *)url;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *urlLabel;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *historyBackButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *historyForwardButton;

@property (nonatomic, retain) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomToolbar;

- (IBAction)historyBack:(id)sender;
- (IBAction)historyForward:(id)sender;
- (IBAction)refresh:(id)sender;

- (IBAction)goBack:(id)sender;
- (IBAction)showActions:(id)sender;

@end
