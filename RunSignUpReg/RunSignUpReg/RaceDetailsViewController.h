//
//  RaceDetailsViewController.h
//  RunSignUpReg
//
// Copyright 2014 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RoundedLoadingIndicator.h"
#import <EventKitUI/EventKitUI.h>
#import "SignInViewController.h"
#import <MessageUI/MessageUI.h>

@interface RaceDetailsViewController : UIViewController <EKEventEditViewDelegate, UIActionSheetDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, SignInViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    NSDictionary *dataDict;
    NSDateFormatter *eventDateFormatter;
        
    UITableView *registrationTable;
        
    int chosenRegistration;
    
    UILabel *placeHintLabel;
    UILabel *descriptionHintLabel;
    
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *placeLabel;
    
    UIButton *viewResultsButton;
    UIButton *signUpButton1;
    UIButton *signUpButton2;
    UIButton *remindMeButton;
    
    UILabel *addressLine1;
    UILabel *addressLine2;
    
    MKMapView *mapView;
    UIButton *viewMapButton;
    UIButton *viewMapOtherButton;
    CLLocationCoordinate2D addressLocation;
    
    int eventsToCheckForResults;
    UIWebView *descriptionView;
    BOOL hasLoadedDescription;
    BOOL hasLoadedDetails;
    BOOL hasLoadedResultsDetails;
    BOOL attemptedToSignUpWithoutDetails;
    
    EKEventStore *store;
    
    RoundedLoadingIndicator *rli;
    
    UIScrollView *scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data;

@property (nonatomic, retain) NSDictionary *dataDict;

@property (nonatomic, retain) IBOutlet UITableView *registrationTable;

@property (nonatomic, retain) IBOutlet UILabel *placeHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionHintLabel;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeLabel;

@property (nonatomic, retain) IBOutlet UIButton *viewResultsButton;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton1;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton2;
@property (nonatomic, retain) IBOutlet UIButton *remindMeButton;

@property (nonatomic, retain) IBOutlet UILabel *addressLine1;
@property (nonatomic, retain) IBOutlet UILabel *addressLine2;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *viewMapButton;
@property (nonatomic, retain) IBOutlet UIButton *viewMapOtherButton;

@property (nonatomic, retain) IBOutlet UIWebView *descriptionView;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)signUp:(id)sender;
- (IBAction)viewMap:(id)sender;
- (IBAction)viewMapOther:(id)sender;
- (IBAction)viewResults:(id)sender;

- (IBAction)createCalendarEvent:(id)sender;

- (void)showEventEditViewWithEvent:(EKEvent *)event;

- (CLLocationCoordinate2D)getLocationFromAddressString:(NSString*)addressStr;

- (void)layoutContent;

@end
