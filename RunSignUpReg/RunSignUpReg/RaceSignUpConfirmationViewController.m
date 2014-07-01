//
//  RaceSignUpConfirmationViewController.m
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

#import "RaceSignUpConfirmationViewController.h"
#import "RaceSignUpEventTableViewCell.h"
#import "RSUModel.h"

@implementation RaceSignUpConfirmationViewController
@synthesize rli;

@synthesize raceNameLabel;
@synthesize registeredLabel;
@synthesize eventsTable;

@synthesize registrantView;
@synthesize nameLabel;
@synthesize emailLabel;
@synthesize dobLabel;
@synthesize genderLabel;
@synthesize phoneLabel;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize zipLabel;

@synthesize totalLabel;

@synthesize otherView;
@synthesize totalView;
@synthesize scrollView;
@synthesize mistakeButton;
@synthesize mainMenuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching Cost..."];
        [self.view addSubview: rli];
        [rli release];
    }
    
    self.title = @"Congratulations!";
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [mistakeButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [mistakeButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [mainMenuButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [mainMenuButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    [raceNameLabel setText: [dataDict objectForKey: @"name"]];
    
    NSDictionary *userDict = nil;
    if([[RSUModel sharedModel] signedIn]){
        if([[RSUModel sharedModel] registrantType] == RSURegistrantMe){
            userDict = [[RSUModel sharedModel] currentUser];
        }else{ //someoneelse or secondary
            userDict = [dataDict objectForKey:@"registrant"];
        }
    }else if([[RSUModel sharedModel] registrantType] == RSURegistrantNewUser){
        userDict = [dataDict objectForKey:@"registrant"];
    }
    
    NSString *name = [NSString stringWithFormat: @"%@ %@", [userDict objectForKey: @"first_name"], [userDict objectForKey: @"last_name"]];
    
    [nameLabel setText: name];
    [emailLabel setText: [userDict objectForKey: @"email"]];
    [dobLabel setText: [userDict objectForKey: @"dob"]];
    [genderLabel setText: [userDict objectForKey: @"gender"]];
    [phoneLabel setText: [userDict objectForKey: @"phone"]];
    [addressLabel setText: [[userDict objectForKey: @"address"] objectForKey:@"street"]];
    [cityLabel setText: [[userDict objectForKey: @"address"] objectForKey:@"city"]];
    [stateLabel setText: [[userDict objectForKey: @"address"] objectForKey:@"state"]];
    [zipLabel setText: [[userDict objectForKey: @"address"] objectForKey:@"zipcode"]];
    
    [totalLabel setText: [dataDict objectForKey: @"total_cost"]];
    
    NSLog(@"Data: %@", dataDict);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [formatter setTimeStyle: NSDateFormatterShortStyle];
    
    [registeredLabel setText: [formatter stringFromDate: [NSDate date]]]; //current time
    
    UIBarButtonItem *printItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printConfirmation)];
    
    [self.navigationItem setHidesBackButton: YES];
    [self.navigationItem setRightBarButtonItem:printItem animated:YES];
    [self.navigationController.navigationBar setNeedsDisplay];
    
    [printItem release];
    
    [self layoutContent];
}

- (void)printConfirmation{
    UIPrintInteractionController *printInteractionController = [UIPrintInteractionController sharedPrintController];
    NSString *markupText = [NSString stringWithFormat:@"<html><head><style>body{font-family: \"Helvetica\", \"Arial\", sans-serif;}h3{color: #0094CC;}.title{}.subheading{color: #DEAB4C;}ul{padding-left: 15px;list-style-type: none;}li{padding: 5px 0 5px 0;}</style></head><body><h3>Race Information</h3><span class=\"subheading\">Race:&nbsp;</span>%@<br /><span class=\"subheading\">Date:&nbsp;</span>%@<br /><span class=\"subheading\">Location:&nbsp;</span>%@<br /><span class=\"subheading\">Registered:&nbsp;</span>%@<br /><h3>Event(s)</h3><ul>",
                            [raceNameLabel text], [dataDict objectForKey:@"start_date"], [NSString stringWithFormat:@"%@ - %@", [[dataDict objectForKey:@"address"] objectForKey:@"street"], [[RSUModel sharedModel] addressLine2FromAddress: [dataDict objectForKey:@"address"]]], [registeredLabel text]];
    
    for(NSDictionary *event in [dataDict objectForKey: @"events"]){
        markupText = [markupText stringByAppendingFormat:@"<li><b>%@</b> - %@</li>", [event objectForKey:@"name"], [event objectForKey: @"start_time"]];
    }
    
    markupText = [markupText stringByAppendingFormat:@"</ul><h3>Registrant</h3><span class=\"subheading\">Name:&nbsp;</span>%@<br /><span class=\"subheading\">E-mail:&nbsp;</span>%@<br /><span class=\"subheading\">Date of Birth:&nbsp;</span>%@<br /><span class=\"subheading\">Gender:&nbsp;</span>%@<br /><span class=\"subheading\">Phone:&nbsp;</span>%@<br /><span class=\"subheading\">Address:&nbsp;</span>%@<br /><span class=\"subheading\">City:&nbsp;</span>%@<br /><span class=\"subheading\">State:&nbsp;</span>%@<br /><span class=\"subheading\">Zip Code:&nbsp;</span>%@<br /><h3>Total</h3>%@</body></html>",
                  [nameLabel text], [emailLabel text], [dobLabel text], [genderLabel text], [phoneLabel text],
                  [addressLabel text], [cityLabel text], [stateLabel text], [zipLabel text], @"$0.00"];
    
    UIMarkupTextPrintFormatter *printFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: markupText];
    [printInteractionController setPrintFormatter: printFormatter];
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error){
        if(!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
    };
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [printInteractionController presentAnimated:YES completionHandler:completionHandler];
    }else{
        [printInteractionController presentFromBarButtonItem:[self.navigationItem rightBarButtonItem] animated:YES completionHandler:completionHandler];
    }
}

- (void)layoutContent{
    [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, eventsTable.frame.size.width, [eventsTable rowHeight] * [eventsTable numberOfRowsInSection: 0])];
    [registrantView setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, registrantView.frame.size.width, registrantView.frame.size.height)];
    [totalView setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, totalView.frame.size.width, totalView.frame.size.height)];
    [otherView setFrame: CGRectMake(4, totalView.frame.origin.y + totalView.frame.size.height + 8, otherView.frame.size.width, otherView.frame.size.height)];
    [scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, otherView.frame.origin.y + otherView.frame.size.height + 8)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *EventCellIdentifier = @"EventCellIdentifier";
    RaceSignUpEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
    if(cell == nil){
        cell = [[RaceSignUpEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventCellIdentifier];
        [cell setShowPrice: NO];
    }
    
    [[cell nameLabel] setText: [[[dataDict objectForKey: @"events"] objectAtIndex: indexPath.row] objectForKey: @"name"]];
    NSDictionary *firstRegPeriod = [[[[dataDict objectForKey: @"events"] objectAtIndex: indexPath.row] objectForKey: @"registration_periods"] objectAtIndex: 0];
    [cell setPrice:[firstRegPeriod objectForKey: @"race_fee"] price2:[firstRegPeriod objectForKey: @"processing_fee"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == eventsTable){
        return [[dataDict objectForKey: @"events"] count];
    }else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)clearTransaction:(id)sender{
    void (^response)(RSUConnectionResponse, NSDictionary *) = ^(RSUConnectionResponse didSucceed, NSDictionary *data){
        [rli fadeOut];
        
        if(didSucceed == RSUSuccess){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully refunded your transaction." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [mistakeButton setEnabled: NO];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to refund race." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    };
    
    [[rli label] setText: @"Refunding..."];
    [rli fadeIn];
    [[RSUModel sharedModel] registerForRace:[dataDict objectForKey:@"race_id"] withInfo:dataDict requestType:RSURegRefund response:response];
}

- (IBAction)returnToMainMenu:(id)sender{
    [[rli label] setText:@"Refreshing..."];
    [rli fadeIn];
    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
        [rli fadeOut];
        [self.navigationController popToRootViewControllerAnimated: YES];
    };
    
    [[RSUModel sharedModel] retrieveUserInfo:response];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
