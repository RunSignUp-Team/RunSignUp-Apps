//
//  RaceDetailsViewController.m
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

#import "RaceDetailsViewController.h"
#import "RaceResultsViewController.h"
#import "RaceDetailsEventTableViewCell.h"
#import "RaceDetailsRegistrationTableViewCell.h"
#import "RSUModel.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "RaceSignUpChooseRegistrantViewController.h"
#import "AddressAnnotation.h"

@implementation RaceDetailsViewController
@synthesize dataDict;
@synthesize registrationTable;
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
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:[[UIScreen mainScreen] bounds].size.width / 2 - 80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching Details..."];
        
        self.title = @"Details";
        hasLoadedDescription = NO;
        hasLoadedDetails = NO;
        hasLoadedResultsDetails = NO;
        
        chosenRegistration = -1;
        
        attemptedToSignUpWithoutDetails = NO;
        eventDateFormatter = [[NSDateFormatter alloc] init];
        [eventDateFormatter setAMSymbol: @"am"];
        [eventDateFormatter setPMSymbol: @"pm"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview: rli];
    [rli release];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *darkBlueButtonImage = [UIImage imageNamed:@"DarkBlueButton.png"];
    UIImage *stretchedDarkBlueButton = [darkBlueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *darkBlueButtonTapImage = [UIImage imageNamed:@"DarkBlueButtonTap.png"];
    UIImage *stretchedDarkBlueButtonTap = [darkBlueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [viewResultsButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [viewResultsButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    [signUpButton1 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signUpButton2 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signUpButton1 setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    [signUpButton2 setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    [viewMapButton setBackgroundImage:stretchedDarkBlueButton forState:UIControlStateNormal];
    [viewMapOtherButton setBackgroundImage:stretchedDarkBlueButton forState:UIControlStateNormal];
    [viewMapButton setBackgroundImage:stretchedDarkBlueButtonTap forState:UIControlStateHighlighted];
    [viewMapOtherButton setBackgroundImage:stretchedDarkBlueButtonTap forState:UIControlStateHighlighted];
    [remindMeButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    
    for(UILabel *label in @[dateLabel, placeLabel, addressLine1, addressLine2, descriptionHintLabel]){
        [label setFont: [UIFont fontWithName:@"OpenSans" size:[[label font] pointSize]]];
    }
    
    for(UILabel *label in @[nameLabel, placeHintLabel, descriptionHintLabel]){
        [label setFont: [UIFont fontWithName:@"OpenSans-Bold" size:[[label font] pointSize]]];
    }
    
    for(UIButton *button in @[remindMeButton, viewResultsButton, signUpButton1, signUpButton2, viewMapButton, viewMapOtherButton]){
        [[button titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:[[[button titleLabel] font] pointSize]]];
    }
    
    [nameLabel setText: [dataDict objectForKey: @"name"]];
    [dateLabel setText: [dataDict objectForKey: @"next_date"]];
    [placeLabel setText: [RSUModel addressLine2FromAddress: [dataDict objectForKey:@"address"]]];
    [addressLine1 setText: [[dataDict objectForKey: @"address"] objectForKey:@"street"]];
    [addressLine2 setText: [RSUModel addressLine2FromAddress: [dataDict objectForKey:@"address"]]];
    
    NSString *htmlString = [dataDict objectForKey: @"description"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    htmlString = [NSString stringWithFormat: @"<link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'><span style=\"font-family: 'Open Sans'; color: #007291 \">%@</span>", htmlString];
    
    [descriptionView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.runsignup.com/"]];
    
    [rli fadeIn];
    void (^response)(NSMutableDictionary *) = ^(NSMutableDictionary *race){
        self.dataDict = race;
        hasLoadedDetails = YES;
        if(attemptedToSignUpWithoutDetails)
            [self signUp: nil];
        
        NSLog(@"%@", dataDict);
        attemptedToSignUpWithoutDetails = NO;
        
        if([race objectForKey: @"longitude"] && [race objectForKey: @"latitude"]){
            float latitude = [[race objectForKey: @"latitude"] floatValue];
            float longitude = [[race objectForKey: @"longitude"] floatValue];
            addressLocation = CLLocationCoordinate2DMake(latitude, longitude);
            [mapView setRegion: MKCoordinateRegionMake(addressLocation, MKCoordinateSpanMake(0.005, 0.003))]; // these two just trial and error

            AddressAnnotation *addr = [[AddressAnnotation alloc] initWithCoordinate: addressLocation];
            [mapView addAnnotation: addr];
            [addr release];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                addressLocation = [self getLocationFromAddressString:[NSString stringWithFormat:@"%@, %@", [[dataDict objectForKey: @"address"] objectForKey:@"street"], [RSUModel addressLine2FromAddress:[dataDict objectForKey:@"address"]]]];
                [mapView setRegion: MKCoordinateRegionMake(addressLocation, MKCoordinateSpanMake(0.005, 0.003))]; // these two just trial and error
                
                AddressAnnotation *addr = [[AddressAnnotation alloc] initWithCoordinate: addressLocation];
                [mapView addAnnotation: addr];
                [addr release];
            });
        }
        
        eventsToCheckForResults = [[dataDict objectForKey: @"events"] count];
        // Check if any events in race have results, if so enable view results button
        for(NSDictionary *event in [dataDict objectForKey: @"events"]){
            void (^response)(NSArray *) = ^(NSArray *resultSets){
                if([resultSets count] > 0){
                    [viewResultsButton setEnabled: YES];
                    hasLoadedResultsDetails = YES;
                }else{
                    eventsToCheckForResults--;
                    if(eventsToCheckForResults == 0)
                        hasLoadedResultsDetails = YES;
                }
            };
            
            [[RSUModel sharedModel] retrieveEventResultSetsWithRaceID:[dataDict objectForKey:@"race_id"] eventID:[event objectForKey:@"event_id"] response:response];
        }
        
        [registrationTable reloadData];
    };
    
    [[RSUModel sharedModel] retrieveRaceDetailsWithRaceID:[dataDict objectForKey: @"race_id"] response:response];
    [self layoutContentIfFullyLoaded];
}

- (void)layoutContentIfFullyLoaded{
    if(hasLoadedDescription && hasLoadedDetails && hasLoadedResultsDetails)
        [self layoutContent];
    else
        [self performSelector:@selector(layoutContentIfFullyLoaded) withObject:nil afterDelay:0.1f];
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
    
    hasLoadedDescription = YES;
}

- (IBAction)viewResults:(id)sender{
    if([[RSUModel sharedModel] signedIn]){
        [self didSignInEmail: nil];
    }else{
        SignInViewController *sivc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        [sivc setDelegate: self];
        [self presentViewController:sivc animated:YES completion:nil];
        [sivc release];
    }
}

- (void)didSignInEmail:(NSString *)email{
    NSMutableDictionary *dataDictCopy = [[NSMutableDictionary alloc] initWithDictionary:dataDict copyItems:YES];
    RaceResultsViewController *rrvc = [[RaceResultsViewController alloc] initWithNibName:@"RaceResultsViewController" bundle:nil data:dataDictCopy];
    [self.navigationController pushViewController:rrvc animated:YES];
    [rrvc release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(!hasLoadedDescription){
        return YES;
    }else{
        // Intercept link clicks and send them to safari
        [[UIApplication sharedApplication] openURL: request.URL];
        return NO;
    }
}

- (void)layoutContent{
    [rli fadeOut];
    
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if([viewResultsButton isEnabled]){
        [viewResultsButton setHidden: NO];
        [viewResultsButton setFrame: CGRectMake(4, viewResultsButton.frame.origin.y, [self.view frame].size.width - 8, viewResultsButton.frame.size.height)];
        [signUpButton1 setFrame: CGRectMake(4, viewResultsButton.frame.origin.y + viewResultsButton.frame.size.height + 4, signUpButton1.frame.size.width, signUpButton1.frame.size.height)];
    }else{
        [viewResultsButton setHidden: YES];
        [signUpButton1 setFrame: CGRectMake(4, viewResultsButton.frame.origin.y, signUpButton1.frame.size.width, signUpButton1.frame.size.height)];
    }
    
    [remindMeButton setFrame: CGRectMake(remindMeButton.frame.origin.x, signUpButton1.frame.origin.y, remindMeButton.frame.size.width, remindMeButton.frame.size.height)];

    if([[dataDict objectForKey: @"is_registration_open"] boolValue] && [self tableView:registrationTable numberOfRowsInSection:0] > 0){
        [registrationTable setFrame: CGRectMake(4, signUpButton1.frame.origin.y + signUpButton1.frame.size.height + 8, [self.view frame].size.width - 8, [registrationTable numberOfRowsInSection: 0] * 116)];
    }else{
        [registrationTable setFrame: CGRectMake(4, signUpButton1.frame.origin.y + signUpButton1.frame.size.height + 8, [self.view frame].size.width - 8, 0)];
        [signUpButton1 setBackgroundImage:[signUpButton1 backgroundImageForState: UIControlStateDisabled] forState:UIControlStateNormal];
        [signUpButton1 setBackgroundImage:[signUpButton1 backgroundImageForState: UIControlStateDisabled] forState:UIControlStateHighlighted];
        [signUpButton2 setBackgroundImage:[signUpButton2 backgroundImageForState: UIControlStateDisabled] forState:UIControlStateNormal];
        [signUpButton2 setBackgroundImage:[signUpButton2 backgroundImageForState: UIControlStateDisabled] forState:UIControlStateHighlighted];
    }
    
    
    [placeHintLabel setFrame: CGRectMake(4, registrationTable.frame.origin.y + registrationTable.frame.size.height + 8, [self.view frame].size.width - 8, placeHintLabel.frame.size.height)];
    [addressLine1 setFrame: CGRectMake(4, placeHintLabel.frame.origin.y + placeHintLabel.frame.size.height + 4, [self.view frame].size.width - 8, addressLine1.frame.size.height)];
    [addressLine2 setFrame: CGRectMake(4, addressLine1.frame.origin.y + addressLine1.frame.size.height, [self.view frame].size.width - 8, addressLine2.frame.size.height)];
    [mapView setFrame: CGRectMake(4, addressLine2.frame.origin.y + addressLine2.frame.size.height + 8, [self.view frame].size.width - 8, mapView.frame.size.height)];
    [viewMapButton setFrame: CGRectMake(4, mapView.frame.origin.y + mapView.frame.size.height + 8, viewMapButton.frame.size.width, 46)];
    [viewMapOtherButton setFrame: CGRectMake(viewMapOtherButton.frame.origin.x, mapView.frame.origin.y + mapView.frame.size.height + 8, viewMapOtherButton.frame.size.width, 46)];
    [descriptionHintLabel setFrame: CGRectMake(4, viewMapButton.frame.origin.y + viewMapButton.frame.size.height + 8, [self.view frame].size.width - 8, descriptionHintLabel.frame.size.height)];
    //CGSize size = [[dataDict objectForKey: @"Description"] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake([self.view frame].size.width - 8, 1000) lineBreakMode:UILineBreakModeWordWrap];
    //[descriptionLabel setFrame: CGRectMake(4, descriptionHintLabel.frame.origin.y + descriptionHintLabel.frame.size.height + 8, [self.view frame].size.width - 8, size.height)];
    [descriptionView setFrame: CGRectMake(4, descriptionHintLabel.frame.origin.y + descriptionHintLabel.frame.size.height + 8, [self.view frame].size.width - 8, descriptionView.frame.size.height)];
    [signUpButton2 setFrame: CGRectMake(4, descriptionView.frame.origin.y + descriptionView.frame.size.height + 8, [self.view frame].size.width - 8, 46)];
    [scrollView setContentSize: CGSizeMake(screenWidth, signUpButton2.frame.origin.y + signUpButton2.frame.size.height + 4)];
}

- (IBAction)signUp:(id)sender{
    if(hasLoadedDetails){
        if([[dataDict objectForKey: @"is_registration_open"] boolValue] && [self tableView:registrationTable numberOfRowsInSection:0] > 0){
            if([[dataDict objectForKey: @"can_use_registration_api"] boolValue]){
                NSMutableDictionary *dataDictCopy = [[NSMutableDictionary alloc] initWithDictionary:dataDict copyItems:YES];
                if(chosenRegistration != -1)
                    [dataDictCopy setObject:[NSNumber numberWithInt: chosenRegistration] forKey:@"chosenRegistration"];
                RaceSignUpChooseRegistrantViewController *rsucrvc = [[RaceSignUpChooseRegistrantViewController alloc] initWithNibName:@"RaceSignUpChooseRegistrantViewController" bundle:nil data:dataDictCopy];
                [self.navigationController pushViewController:rsucrvc animated:YES];
                [rsucrvc release];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Unavailable" message:@"Registration for this race requires features of RunSignUp that are unavailable in the mobile app." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"SignUp Online", nil];
                [alert show];
                [alert release];
            }
        }else if([self tableView:registrationTable numberOfRowsInSection:0] > 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Isn't Open" message:@"Online registration is now closed for this race." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Isn't Open" message:@"There are no events open for online registration at this time." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else{
        attemptedToSignUpWithoutDetails = YES;
        [rli fadeIn];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [dataDict objectForKey: @"url"]]];
    }
}

- (IBAction)viewMap:(id)sender{
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:addressLocation addressDictionary:@{(NSString *)kABPersonAddressStreetKey: [[dataDict objectForKey: @"address"] objectForKey:@"street"],
                                                                                                           (NSString *)kABPersonAddressCityKey: [[dataDict objectForKey: @"address"] objectForKey:@"city"],
                                                                                                           (NSString *)kABPersonAddressStateKey: [[dataDict objectForKey: @"address"] objectForKey: @"state"],
                                                                                                           (NSString *)kABPersonAddressZIPKey: [[dataDict objectForKey: @"address"] objectForKey: @"zipcode"]}];
    
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark: endLocation];
    [endingItem openInMapsWithLaunchOptions: nil];

    /*float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver >= 6.0){
        // ios 6 code
    }else{
    }*/
}

- (void)viewMapOther:(id)sender{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy Address to Clipboard", @"Create New Calendar Event", @"Email Link", @"Copy Race URL", nil];
    [action showFromRect:[viewMapOtherButton frame] inView:scrollView animated:YES];
    [action release];
}

- (IBAction)createCalendarEvent:(id)sender{
    if(store == nil){
        store = [[EKEventStore alloc] init];
    }
    
    EKEvent *event = [EKEvent eventWithEventStore: store];
    [event setTitle: [dataDict objectForKey: @"name"]];
    [event setLocation: [NSString stringWithFormat:@"%@, %@", [[dataDict objectForKey:@"address"] objectForKey:@"street"], [RSUModel addressLine2FromAddress: [dataDict objectForKey:@"address"]]]];
    [event setURL: [NSURL URLWithString: [dataDict objectForKey: @"url"]]];
    [event setCalendar: [store defaultCalendarForNewEvents]];
    
    if([dataDict objectForKey: @"events"] != nil && [[dataDict objectForKey:@"events"] count] >= 1){
        [eventDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSString *firstEventStartTime = [[[dataDict objectForKey: @"events"] objectAtIndex: 0] objectForKey: @"start_time"];
        [event setStartDate: [eventDateFormatter dateFromString: firstEventStartTime]];
        [event setEndDate: [NSDate dateWithTimeInterval:3600.0 sinceDate:[event startDate]]]; // give an hour for race to occur.
    }
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if(granted){
                [self performSelectorOnMainThread:@selector(showEventEditViewWithEvent:) withObject:event waitUntilDone:NO];
            }
        }];
    }else{
        [self performSelectorOnMainThread:@selector(showEventEditViewWithEvent:) withObject:event waitUntilDone:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: [NSString stringWithFormat:@"%@, %@", [[dataDict objectForKey:@"address"] objectForKey:@"street"], [RSUModel addressLine2FromAddress: [dataDict objectForKey:@"address"]]]];
    }else if(buttonIndex == 1){
        [self createCalendarEvent: nil];
    }else if(buttonIndex == 2){
        MFMailComposeViewController *mfmcvc = [[MFMailComposeViewController alloc] init];
        [mfmcvc setMailComposeDelegate: self];
        [mfmcvc setSubject: [dataDict objectForKey: @"name"]];
        [mfmcvc setMessageBody: [dataDict objectForKey: @"url"] isHTML: NO];
        [self presentViewController:mfmcvc animated:YES completion:nil];
        [mfmcvc release];
    }else if(buttonIndex == 3){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: [dataDict objectForKey: @"url"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if(tableView == registrationTable){
        static NSString *RegistrationCellIdentifier = @"RegistrationCellIdentifier";
        RaceDetailsRegistrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationCellIdentifier];
        
        if(cell == nil){
            cell = [[RaceDetailsRegistrationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RegistrationCellIdentifier];
        }
        
        NSDictionary *actualEvent = nil;
        NSDictionary *actualRegPeriod = nil;
        int index = indexPath.row;
        
        [eventDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];

        for(NSDictionary *event in [dataDict objectForKey: @"events"]){
            NSDate *startDate = [eventDateFormatter dateFromString: [event objectForKey: @"start_time"]];
            if([startDate compare: [NSDate date]] == NSOrderedDescending)
                index--;
            
            if(index < 0){
                actualEvent = event;
                
                for(NSDictionary *regPeriod in [event objectForKey: @"registration_periods"]){
                    NSDate *openDate = [eventDateFormatter dateFromString: [regPeriod objectForKey: @"registration_opens"]];
                    NSDate *closeDate = [eventDateFormatter dateFromString: [regPeriod objectForKey: @"registration_closes"]];
                    
                    actualRegPeriod = nil;
                    
                    if([openDate compare: [NSDate date]] == NSOrderedAscending && [closeDate compare: [NSDate date]] == NSOrderedDescending){
                        actualRegPeriod = regPeriod;
                        break;
                    }
                }
                
                if(actualRegPeriod){
                    break;
                }else{
                    index++;
                }
            }
        }
        
        if(actualEvent && actualRegPeriod){
            [cell setPrice:[actualRegPeriod objectForKey: @"race_fee"] price2:[actualRegPeriod objectForKey: @"processing_fee"]];
            [eventDateFormatter setDateFormat: @"MM/dd/yyyy HH:mm"];
            NSDate *openDate = [eventDateFormatter dateFromString: [actualRegPeriod objectForKey: @"registration_opens"]];
            NSDate *closeDate = [eventDateFormatter dateFromString: [actualRegPeriod objectForKey: @"registration_closes"]];
            [eventDateFormatter setDateFormat: @"MMMM dd, yyyy @ h:mma"];
            
            [[cell titleLabel] setText: [NSString stringWithFormat: @"%@", [actualEvent objectForKey: @"name"]]];
            [[cell increaseLabel] setText: [NSString stringWithFormat: @"Price increases after %@ ET", [eventDateFormatter stringFromDate: closeDate]]];
            
            [eventDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
            NSString *eventStartTime = [actualEvent objectForKey:@"start_time"];
            NSDate *formattedDate = [eventDateFormatter dateFromString: eventStartTime];
            [eventDateFormatter setDateFormat:@"h:mm a"];
            [[cell startTimeLabel] setText: [NSString stringWithFormat: @"Start Time: %@", [eventDateFormatter stringFromDate: formattedDate]]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == registrationTable){
        chosenRegistration = indexPath.row;
        [self signUp: nil];
        //chosenRegistration = -1;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(hasLoadedDetails){
        int scheduledEventsWithOpenReg = 0;
        for(NSDictionary *event in [dataDict objectForKey: @"events"]){
            [eventDateFormatter setDateFormat: @"MM/dd/yyyy HH:mm"];
            NSDate *startDate = [eventDateFormatter dateFromString: [event objectForKey: @"start_time"]];
            if([startDate compare: [NSDate date]] == NSOrderedDescending){
                BOOL regOpen = NO;
                for(NSDictionary *regPeriod in [event objectForKey: @"registration_periods"]){
                    NSDate *openDate = [eventDateFormatter dateFromString: [regPeriod objectForKey: @"registration_opens"]];
                    NSDate *closeDate = [eventDateFormatter dateFromString: [regPeriod objectForKey: @"registration_closes"]];
                    
                    if([openDate compare: [NSDate date]] == NSOrderedAscending && [closeDate compare: [NSDate date]] == NSOrderedDescending)
                        regOpen = YES;
                }
                if(regOpen)
                    scheduledEventsWithOpenReg++;
            }
        }
        return scheduledEventsWithOpenReg;
    
    }else{
        return 0;
    }
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
