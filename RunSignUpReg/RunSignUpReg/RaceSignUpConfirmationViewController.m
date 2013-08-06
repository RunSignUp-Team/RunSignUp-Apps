//
//  RaceSignUpConfirmationViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/6/13.
//
//

#import "RaceSignUpConfirmationViewController.h"
#import "RaceSignUpEventTableViewCell.h"
#import "RSUModel.h"

@implementation RaceSignUpConfirmationViewController
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
@synthesize tshirtLabel;

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
    }
    
    self.title = @"Congratulations!";
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [mistakeButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [mistakeButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [mainMenuButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [mainMenuButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    [raceNameLabel setText: [dataDict objectForKey: @"Name"]];
    int tshirtSize = [[dataDict objectForKey: @"TShirtSize"] intValue];
    
    switch(tshirtSize){
        case 0:
            [tshirtLabel setText: @"Small"];
            break;
        case 1:
            [tshirtLabel setText: @"Medium"];
            break;
        case 2:
            [tshirtLabel setText: @"Large"];
            break;
        case 3:
            [tshirtLabel setText: @"Extra Large"];
            break;
        default:
            [tshirtLabel setText: @"No T-Shirt Chosen"];
            break;
    }
    
    if(REGISTRATION_REQUIRES_LOGIN && [[RSUModel sharedModel] lastParsedUser] != nil){
        NSString *name = [NSString stringWithFormat: @"%@ %@", [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"FName"], [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"LName"]];
        
        [nameLabel setText: name];
        [emailLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"Email"]];
        [dobLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"DOB"]];
        [genderLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"Gender"]];
        [phoneLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"Phone"]];
        [addressLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"Street"]];
        [cityLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"City"]];
        [stateLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"State"]];
        [zipLabel setText: [[[RSUModel sharedModel] lastParsedUser] objectForKey: @"Zipcode"]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [formatter setTimeStyle: NSDateFormatterShortStyle];
    
    [registeredLabel setText: [formatter stringFromDate: [NSDate date]]]; //current time
    
    UIBarButtonItem *printItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printConfirmation)];
    
    [self.navigationItem setHidesBackButton: YES];
    [self.navigationItem setRightBarButtonItem:printItem animated:YES];
    [printItem release];
    
    [self layoutContent];
}

- (void)printConfirmation{
    UIPrintInteractionController *printInteractionController = [UIPrintInteractionController sharedPrintController];
    NSString *markupText = [NSString stringWithFormat:@"<html><head><style>body{font-family: \"Helvetica\", \"Arial\", sans-serif;}h3{color: #0094CC;}.title{}.subheading{color: #DEAB4C;}ul{padding-left: 15px;list-style-type: none;}li{padding: 5px 0 5px 0;}</style></head><body><h3>Race Information</h3><span class=\"subheading\">Race:&nbsp;</span>%@<br /><span class=\"subheading\">Date:&nbsp;</span>%@<br /><span class=\"subheading\">Location:&nbsp;</span>%@<br /><span class=\"subheading\">Registered:&nbsp;</span>%@<br /><h3>Event(s)</h3><ul>",
                            [raceNameLabel text], [dataDict objectForKey:@"Date"], [NSString stringWithFormat:@"%@ - %@", [dataDict objectForKey:@"AL1"], [dataDict objectForKey:@"AL2"]], [registeredLabel text]];
    
    for(NSDictionary *event in [dataDict objectForKey: @"Events"]){
        markupText = [markupText stringByAppendingFormat:@"<li><b>%@</b> - %@</li>", [event objectForKey:@"Name"], [event objectForKey: @"StartTime"]];
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
    
    [[cell nameLabel] setText: [[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"Name"]];
    NSDictionary *firstRegPeriod = [[[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"EventRegistrationPeriods"] objectAtIndex: 0];
    [cell setPrice:[firstRegPeriod objectForKey: @"RegistrationFee"] price2:[firstRegPeriod objectForKey: @"RegistrationProcessingFee"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == eventsTable){
        return [[dataDict objectForKey: @"Events"] count];
    }else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)clearTransaction:(id)sender{
    
}

- (IBAction)returnToMainMenu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
