//
//  RaceSignUpPaymentViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpPaymentViewController.h"
#import "RaceSignUpEventTableViewCell.h"
#import "RaceSignUpConfirmationViewController.h"
#import "RSUModel.h"

@implementation RaceSignUpPaymentViewController
@synthesize raceNameLabel;
@synthesize eventsTable;
@synthesize registrationCartView;
@synthesize couponView;
@synthesize registrantView;
@synthesize scrollView;
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

@synthesize registrationCartHintLabel;
@synthesize baseCostHintLabel;
@synthesize baseCostLabel;
@synthesize processingFeeHintLabel;
@synthesize processingFeeLabel;
@synthesize totalHintLabel;
@synthesize totalLabel;
@synthesize couponField;
@synthesize couponHintLabel;
@synthesize applyButton;

@synthesize paymentHintLabel;
@synthesize paymentButton;

@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        dataDict = data;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Retrieving Info..."];
        [self.view addSubview: rli];
        [rli release];
        
        isFreeRace = YES;
        
        self.title = @"Payment";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [applyButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [applyButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    [paymentButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [paymentButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
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
    
    void (^response)(RSUConnectionResponse, NSDictionary *) = ^(RSUConnectionResponse didSucceed, NSDictionary *data){
        if(didSucceed == RSUSuccess){
            if(data != nil){
                
            }else{
                
            }
        }else if(didSucceed == RSUInvalidData){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid data, please double check your registrant information and try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else if(didSucceed == RSUNoConnection){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        [rli fadeOut];
        [self layoutContent];
    };
    [[RSUModel sharedModel] retrieveRaceRegistrationInformation:response];
}

- (void)layoutContent{
    if(isFreeRace){
        [couponView setHidden: YES];
        [paymentButton setTitle:@"Confirm Registration" forState:UIControlStateNormal];
        [paymentHintLabel setHidden: YES];
        
        [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, eventsTable.frame.size.width, [eventsTable rowHeight] * [eventsTable numberOfRowsInSection: 0])];
        [registrationCartView setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, registrationCartView.frame.size.width, registrationCartView.frame.size.height)];
        //[couponView setFrame: CGRectMake(4, registrationCartView.frame.origin.y + registrationCartView.frame.size.height + 8, couponView.frame.size.width, couponView.frame.size.height)];
        [registrantView setFrame: CGRectMake(4, registrationCartView.frame.origin.y + registrationCartView.frame.size.height + 8, registrantView.frame.size.width, registrantView.frame.size.height)];
        //[paymentHintLabel setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, paymentHintLabel.frame.size.width, paymentHintLabel.frame.size.height)];
        [paymentButton setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, paymentButton.frame.size.width, paymentButton.frame.size.height)];
        [scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, paymentButton.frame.origin.y + paymentButton.frame.size.height + 8)];
    }else{
        [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, eventsTable.frame.size.width, [eventsTable rowHeight] * [eventsTable numberOfRowsInSection: 0])];
        [registrationCartView setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, registrationCartView.frame.size.width, registrationCartView.frame.size.height)];
        [couponView setFrame: CGRectMake(4, registrationCartView.frame.origin.y + registrationCartView.frame.size.height + 8, couponView.frame.size.width, couponView.frame.size.height)];
        [registrantView setFrame: CGRectMake(4, couponView.frame.origin.y + couponView.frame.size.height + 8, registrantView.frame.size.width, registrantView.frame.size.height)];
        [paymentHintLabel setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, paymentHintLabel.frame.size.width, paymentHintLabel.frame.size.height)];
        [paymentButton setFrame: CGRectMake(4, paymentHintLabel.frame.origin.y + paymentHintLabel.frame.size.height + 8, paymentButton.frame.size.width, paymentButton.frame.size.height)];
        [scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, paymentButton.frame.origin.y + paymentButton.frame.size.height + 8)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == eventsTable){
        static NSString *EventCellIdentifier = @"EventCellIdentifier";
        RaceSignUpEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
        if(cell == nil){
            cell = [[RaceSignUpEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventCellIdentifier];
        }
        
        [[cell nameLabel] setText: [[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"Name"]];
        NSDictionary *firstRegPeriod = [[[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"EventRegistrationPeriods"] objectAtIndex: 0];
        [cell setPrice:[firstRegPeriod objectForKey: @"RegistrationFee"] price2:[firstRegPeriod objectForKey: @"RegistrationProcessingFee"]];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [[cell textLabel] setText: @""];
        return cell;
    }
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

- (IBAction)confirmPayment:(id)sender{
    if(!isFreeRace){
        if([[RSUModel sharedModel] paymentViewController] == nil){
            [[RSUModel sharedModel] setPaymentViewController: [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:YES]];
            [[[RSUModel sharedModel] paymentViewController] setDelegate: [RSUModel sharedModel]];
        }
        
        [[RSUModel sharedModel] setDataDict: dataDict];
        [self.navigationController pushViewController:[[RSUModel sharedModel] paymentViewController] animated:YES];
    }else{
        [[RSUModel sharedModel] setDataDict: dataDict];
        // Send data
        RaceSignUpConfirmationViewController *rsucvc = [[RaceSignUpConfirmationViewController alloc] initWithNibName:@"RaceSignUpConfirmationViewController" bundle:Nil data:dataDict];
        [self.navigationController pushViewController:rsucvc animated:YES];
        [rsucvc release];
    }
}

- (IBAction)applyCoupon:(id)sender{

}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
