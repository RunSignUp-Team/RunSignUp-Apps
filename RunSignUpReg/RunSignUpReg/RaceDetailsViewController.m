//
//  RaceDetailsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceDetailsViewController.h"
#import "RaceResultsViewController.h"
#import "RaceDetailsEventTableViewCell.h"
#import "RaceDetailsRegistrationTableViewCell.h"
#import "RSUModel.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "RaceSignUpChooseRegistrantViewController.h"

@implementation RaceDetailsViewController
@synthesize dataDict;
@synthesize eventsTable;
@synthesize registrationTable;
@synthesize eventsHintLabel;
@synthesize placeHintLabel;
@synthesize descriptionHintLabel;
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize placeLabel;
@synthesize viewResultsButton;
@synthesize signUpButton1;
@synthesize signUpButton2;
@synthesize remindMeButton;
@synthesize addressLine1;
@synthesize addressLine2;
@synthesize mapView;
@synthesize viewMapButton;
@synthesize viewMapOtherButton;
@synthesize descriptionView;
@synthesize rli;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.dataDict = data;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Retrieving Details..."];
        [self.view addSubview: rli];
        [rli release];
        
        self.title = @"Details";
        loadedDescription = NO;
        hasLoadedDetails = NO;
        attemptedToSignUpWithoutDetails = NO;
        eventDateFormatter = [[NSDateFormatter alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [viewResultsButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [viewResultsButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signUpButton1 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signUpButton1 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signUpButton2 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signUpButton2 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [viewMapButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [viewMapButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [viewMapOtherButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [viewMapOtherButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [remindMeButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [remindMeButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [eventsTable flashScrollIndicators];
    [registrationTable setSeparatorColor: [UIColor colorWithRed:0.3686f green:0.8078f blue:0.9412f alpha:1.0f]];
        
    [nameLabel setText: [dataDict objectForKey: @"Name"]];
    [dateLabel setText: [dataDict objectForKey: @"Date"]];
    [placeLabel setText: [dataDict objectForKey: @"AL2"]];
    [addressLine1 setText: [dataDict objectForKey: @"AL1"]];
    [addressLine2 setText: [dataDict objectForKey: @"AL2"]];
    
    NSString *htmlString = [dataDict objectForKey: @"Description"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    addressLocation = [self getLocationFromAddressString:[NSString stringWithFormat:@"%@, %@", [dataDict objectForKey: @"AL1"], [dataDict objectForKey: @"AL2"]]];
    [mapView setRegion: MKCoordinateRegionMake(addressLocation, MKCoordinateSpanMake(0.005, 0.003))]; // these two just trial and error

    [descriptionView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.runsignup.com/"]];
    
    void (^response)(NSMutableDictionary *) = ^(NSMutableDictionary *race){
        self.dataDict = race;
        hasLoadedDetails = YES;
        [rli fadeOut];
        if(attemptedToSignUpWithoutDetails)
            [self signUp: nil];
        
        NSLog(@"%@", dataDict);
        attemptedToSignUpWithoutDetails = NO;
    };
    
    [[RSUModel sharedModel] retrieveRaceDetailsWithRaceID:[dataDict objectForKey: @"RaceID"] response:response];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect f = webView.frame;
    f.size.height = 1;
    webView.frame = f;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    f.size = fittingSize;
    webView.frame = f;
    
    [self layoutContent];
}

- (IBAction)viewResults:(id)sender{
    RaceResultsViewController *rrvc = [[RaceResultsViewController alloc] initWithNibName:@"RaceResultsViewController" bundle:nil];
    [self.navigationController pushViewController:rrvc animated:YES];
    [rrvc release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(!loadedDescription){
        loadedDescription = YES;
        return YES;
    }else{
        // Intercept link clicks and send them to safari
        [[UIApplication sharedApplication] openURL: request.URL];
        return NO;
    }
}

- (void)layoutContent{
    if(YES){ // if results exist for race, show view results button
        [viewResultsButton setHidden: NO];
        [viewResultsButton setFrame: CGRectMake(4, viewResultsButton.frame.origin.y, 312, viewResultsButton.frame.size.height)];
        [signUpButton1 setFrame: CGRectMake(4, viewResultsButton.frame.origin.y + viewResultsButton.frame.size.height + 8, 312, signUpButton1.frame.size.height)];
        [eventsHintLabel setFrame: CGRectMake(4, signUpButton1.frame.origin.y + signUpButton1.frame.size.height + 8, 312, eventsHintLabel.frame.size.height)];
        [eventsTable setFrame: CGRectMake(4, eventsHintLabel.frame.origin.y + eventsHintLabel.frame.size.height + 8, 312, [[dataDict objectForKey:@"Events"] count] * [eventsTable rowHeight])];
    }else{
        [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, 312, [[dataDict objectForKey:@"Events"] count] * 22)];
    }
    
    if([[dataDict objectForKey: @"RegistrationOpen"] boolValue]){
        [registrationTable setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, 312, [[dataDict objectForKey:@"Events"] count] * [registrationTable rowHeight])];
    }else{
        [registrationTable setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height, 312, 0)];
    }
    
    [placeHintLabel setFrame: CGRectMake(4, registrationTable.frame.origin.y + registrationTable.frame.size.height + 8, 312, placeHintLabel.frame.size.height)];
    [addressLine1 setFrame: CGRectMake(4, placeHintLabel.frame.origin.y + placeHintLabel.frame.size.height + 4, 312, addressLine1.frame.size.height)];
    [addressLine2 setFrame: CGRectMake(4, addressLine1.frame.origin.y + addressLine1.frame.size.height, 312, addressLine2.frame.size.height)];
    [mapView setFrame: CGRectMake(4, addressLine2.frame.origin.y + addressLine2.frame.size.height + 8, 312, mapView.frame.size.height)];
    [viewMapButton setFrame: CGRectMake(4, mapView.frame.origin.y + mapView.frame.size.height + 8, 242, 46)];
    [viewMapOtherButton setFrame: CGRectMake(250, mapView.frame.origin.y + mapView.frame.size.height + 8, 66, 46)];
    [descriptionHintLabel setFrame: CGRectMake(4, viewMapButton.frame.origin.y + viewMapButton.frame.size.height + 8, 312, descriptionHintLabel.frame.size.height)];
    //CGSize size = [[dataDict objectForKey: @"Description"] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(312, 1000) lineBreakMode:UILineBreakModeWordWrap];
    //[descriptionLabel setFrame: CGRectMake(4, descriptionHintLabel.frame.origin.y + descriptionHintLabel.frame.size.height + 8, 312, size.height)];
    [descriptionView setFrame: CGRectMake(4, descriptionHintLabel.frame.origin.y + descriptionHintLabel.frame.size.height + 8, 312, descriptionView.frame.size.height)];
    [signUpButton2 setFrame: CGRectMake(4, descriptionView.frame.origin.y + descriptionView.frame.size.height + 8, 312, 46)];
    [scrollView setContentSize: CGSizeMake(320.0f, signUpButton2.frame.origin.y + signUpButton2.frame.size.height + 4)];
}

- (IBAction)signUp:(id)sender{
    if(hasLoadedDetails){
        NSMutableDictionary *dataDictCopy = [[NSMutableDictionary alloc] initWithDictionary:dataDict copyItems:YES];
        RaceSignUpChooseRegistrantViewController *rsucrvc = [[RaceSignUpChooseRegistrantViewController alloc] initWithNibName:@"RaceSignUpChooseRegistrantViewController" bundle:nil data:dataDictCopy];
        [self.navigationController pushViewController:rsucrvc animated:YES];
        [rsucrvc release];
    }else{
        attemptedToSignUpWithoutDetails = YES;
        [rli fadeIn];
    }
}

- (IBAction)viewMap:(id)sender{
    NSString *string = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%g,%g", addressLocation.latitude, addressLocation.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];

    /*float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver >= 6.0){
        // ios 6 code
    }else{
    }*/
}

- (void)viewMapOther:(id)sender{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Other" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy to Clipboard", @"Create New Calendar Event", nil];
        [action showFromRect:[viewMapOtherButton frame] inView:scrollView animated:YES];
        [action release];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Other" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy to Clipboard", nil];
        [action showFromRect:[viewMapOtherButton frame] inView:scrollView animated:YES];
        [action release];
    }
}

- (IBAction)createCalendarEvent:(id)sender{
    if(store == nil){
        store = [[EKEventStore alloc] init];
    }
    
    EKEvent *event = [EKEvent eventWithEventStore: store];
    [event setTitle: [dataDict objectForKey: @"Name"]];
    [event setLocation: [NSString stringWithFormat:@"%@, %@", [dataDict objectForKey:@"AL1"], [dataDict objectForKey:@"AL2"]]];
    [event setURL: [NSURL URLWithString: [dataDict objectForKey: @"URL"]]];
    [event setCalendar: [store defaultCalendarForNewEvents]];
    
    if([dataDict objectForKey: @"Events"] != nil && [[dataDict objectForKey:@"Events"] count] >= 1){
        [eventDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSString *firstEventStartTime = [[[dataDict objectForKey: @"Events"] objectAtIndex: 0] objectForKey: @"StartTime"];
        [event setStartDate: [eventDateFormatter dateFromString: firstEventStartTime]];
        [event setEndDate: [NSDate dateWithTimeInterval:3600.0 sinceDate:[event startDate]]]; // give an hour for race to occur.
    }
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(granted){
            [self performSelectorOnMainThread:@selector(showEventEditViewWithEvent:) withObject:event waitUntilDone:NO];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: [NSString stringWithFormat:@"%@, %@", [dataDict objectForKey:@"AL1"], [dataDict objectForKey:@"AL2"]]];
    }else if(buttonIndex == 1){
        [self createCalendarEvent: nil];
    }
}

- (void)showEventEditViewWithEvent:(EKEvent *)event{
    EKEventEditViewController *evc = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    [evc setEditViewDelegate: self];
    [evc setEventStore: store];
    [evc setEvent: event];
    
    [self presentViewController:evc animated:YES completion:nil];
    [event release];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller{
    return [store defaultCalendarForNewEvents];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == eventsTable){
        static NSString *EventsCellIdentifier = @"EventsCellIdentifier";
        RaceDetailsEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventsCellIdentifier];
        
        if(cell == nil){
            cell = [[RaceDetailsEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventsCellIdentifier];
        }
        
        NSString *eventName = [[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey:@"Name"];
        NSString *eventStartTime = [[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey:@"StartTime"];
        [eventDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSDate *formattedDate = [eventDateFormatter dateFromString: eventStartTime];
        [eventDateFormatter setDateFormat:@"h:mm a"];
        eventStartTime = [eventDateFormatter stringFromDate: formattedDate];
        
        [[cell nameLabel] setText: eventName];
        [[cell timeLabel] setText: [@": " stringByAppendingString:eventStartTime]];
        [cell layoutSubviews];
                
        return cell;
    }else if(tableView == registrationTable){
        static NSString *RegistrationCellIdentifier = @"RegistrationCellIdentifier";
        RaceDetailsRegistrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationCellIdentifier];
        
        if(cell == nil){
            cell = [[RaceDetailsRegistrationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RegistrationCellIdentifier];
        }
        
        if([[[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"EventRegistrationPeriods"] count] > 0){
            NSDictionary *firstRegPeriod = [[[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"EventRegistrationPeriods"] objectAtIndex: 0];
            [cell setPrice:[firstRegPeriod objectForKey: @"RegistrationFee"] price2:[firstRegPeriod objectForKey: @"RegistrationProcessingFee"]];
            [[cell periodLabel] setText: @"July 11, 2013 @ 12:43pm ET - July 23, 2013 @ 11:59pm ET"];
            [[cell titleLabel] setText: [NSString stringWithFormat: @"Registration: %@", [[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"Name"]]];
        }
        
        return cell;
    }else{
        static NSString *ResultsCellIdentifier = @"ResultsCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultsCellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResultsCellIdentifier];
        }
        
        [[cell textLabel] setText: @"Results (8K)"];
        return cell;
    }
}

- (CLLocationCoordinate2D)getLocationFromAddressString:(NSString*)addressStr{
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?address=%@&sensor=true",
                        [addressStr stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSLog(@"%@", urlStr);
    NSError *error = nil;
    NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:&error];
    
    if(error == nil){
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLString:locationStr encoding:NSUTF8StringEncoding];
        if([[rootXML tag] isEqualToString:@"GeocodeResponse"]){
            RXMLElement *status = [rootXML child: @"status"];
            RXMLElement *result = [rootXML child: @"result"];
            
            if(status != nil && [[status text] isEqualToString: @"OK"] && result != nil){
                RXMLElement *geometry = [result child: @"geometry"];
                if(geometry != nil){
                    RXMLElement *location = [geometry child: @"location"];
                    if(location != nil){
                        RXMLElement *lat = [location child:@"lat"];
                        RXMLElement *lng = [location child: @"lng"];
                        
                        if(lat != nil && lng != nil){
                            double latitude = [lat textAsDouble];
                            double longitude = [lng textAsDouble];
                            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);

                            return loc;
                        }
                    }
                }
            }
        }
        
        return CLLocationCoordinate2DMake(0.0, 0.0);
    }else{
        return CLLocationCoordinate2DMake(0.0, 0.0);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == eventsTable)
        return [[dataDict objectForKey:@"Events"] count];
    else
        return [[dataDict objectForKey:@"Events"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [eventDateFormatter release];
    [store release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
