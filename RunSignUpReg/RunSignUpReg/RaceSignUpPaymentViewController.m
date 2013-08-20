//
//  RaceSignUpPaymentViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpPaymentViewController.h"
#import "RaceSignUpEventTableViewCell.h"
#import "RaceSignUpCartTableViewCell.h"
#import "RaceSignUpConfirmationViewController.h"
#import "RSUModel.h"

@implementation RaceSignUpPaymentViewController
@synthesize raceNameLabel;
@synthesize eventsTable;
@synthesize cartTable;
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
        cartDict = nil;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Retrieving Cost..."];
        [self.view addSubview: rli];
        [rli release];
        
        isFreeRace = NO;
        
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

    if(REGISTRATION_REQUIRES_LOGIN && [[RSUModel sharedModel] currentUser] != nil){
        NSString *name = [NSString stringWithFormat: @"%@ %@", [[[RSUModel sharedModel] currentUser] objectForKey: @"FName"], [[[RSUModel sharedModel] currentUser] objectForKey: @"LName"]];
        
        [nameLabel setText: name];
        [emailLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"Email"]];
        [dobLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"DOB"]];
        [genderLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"Gender"]];
        [phoneLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"Phone"]];
        [addressLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"Street"]];
        [cityLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"City"]];
        [stateLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"State"]];
        [zipLabel setText: [[[RSUModel sharedModel] currentUser] objectForKey: @"Zipcode"]];
    }
    
    void (^response)(RSUConnectionResponse, NSDictionary *) = ^(RSUConnectionResponse didSucceed, NSDictionary *data){
        if(didSucceed == RSUSuccess){
            if(data != nil){
                if([[data objectForKey:@"Cart"] count] == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cart is empty, please try registering again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                
                NSLog(@"%@", data);
                
                cartDict = data;
                [cartTable reloadData];
                
                if([[cartDict objectForKey: @"TotalCost"] isEqualToString:@"$0.00"]){
                    isFreeRace = YES;
                }else{
                    isFreeRace = NO;
                }
                
                [baseCostLabel setText: [data objectForKey:@"BaseCost"]];
                [processingFeeLabel setText: [data objectForKey:@"ProcessingFee"]];
                [totalLabel setText: [data objectForKey:@"TotalCost"]];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid data, please double check your registrant information and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }else if(didSucceed == RSUInvalidData && data != nil){
            if([data objectForKey:@"ErrorArray"] == nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error #%@: %@", [data objectForKey:@"ErrorCode"], [data objectForKey:@"ErrorMessage"]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                NSString *errors = @"Errors: ";
                for(NSString *error in [data objectForKey: @"ErrorArray"]){
                    errors = [errors stringByAppendingFormat:@"%@, ", error];
                }
                errors = [errors substringToIndex: [errors length] - 2];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errors delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }else if(didSucceed == RSUInvalidData){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid data, please double check your registrant information and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else if(didSucceed == RSUNoConnection){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        [rli fadeOut];
        [self layoutContent];
    };
    [[RSUModel sharedModel] registerForRace:[dataDict objectForKey:@"RaceID"] withInfo:dataDict requestType:RSURegGetCart response:response];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)layoutContent{
    if(isFreeRace){
        [couponView setHidden: YES];
        [paymentButton setTitle:@"Confirm Registration" forState:UIControlStateNormal];
        [paymentHintLabel setHidden: YES];
        
        [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, eventsTable.frame.size.width, [eventsTable rowHeight] * [eventsTable numberOfRowsInSection: 0])];
        [cartTable setFrame: CGRectMake(4, cartTable.frame.origin.y, cartTable.frame.size.width, [cartTable rowHeight] * [cartTable numberOfRowsInSection: 0])];
        [baseCostHintLabel setFrame: CGRectMake(4, cartTable.frame.origin.y + cartTable.frame.size.height + 4, baseCostHintLabel.frame.size.width, baseCostHintLabel.frame.size.height)];
        [baseCostLabel setFrame: CGRectMake(baseCostLabel.frame.origin.x, baseCostHintLabel.frame.origin.y, baseCostLabel.frame.size.width, baseCostLabel.frame.size.height)];
        [processingFeeHintLabel setFrame: CGRectMake(4, baseCostLabel.frame.origin.y + baseCostLabel.frame.size.height + 4, processingFeeHintLabel.frame.size.width, processingFeeHintLabel.frame.size.height)];
        [processingFeeLabel setFrame: CGRectMake(processingFeeLabel.frame.origin.x, processingFeeHintLabel.frame.origin.y, processingFeeLabel.frame.size.width, processingFeeLabel.frame.size.height)];
        [totalHintLabel setFrame: CGRectMake(4, processingFeeLabel.frame.origin.y + processingFeeLabel.frame.size.height + 4, totalHintLabel.frame.size.width, totalHintLabel.frame.size.height)];
        [totalLabel setFrame: CGRectMake(totalLabel.frame.origin.x, totalHintLabel.frame.origin.y, totalLabel.frame.size.width, totalLabel.frame.size.height)];
        [registrationCartView setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, registrationCartView.frame.size.width, totalLabel.frame.origin.y + totalLabel.frame.size.height + 8)];
        //[couponView setFrame: CGRectMake(4, registrationCartView.frame.origin.y + registrationCartView.frame.size.height + 8, couponView.frame.size.width, couponView.frame.size.height)];
        [registrantView setFrame: CGRectMake(4, registrationCartView.frame.origin.y + registrationCartView.frame.size.height + 8, registrantView.frame.size.width, registrantView.frame.size.height)];
        //[paymentHintLabel setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, paymentHintLabel.frame.size.width, paymentHintLabel.frame.size.height)];
        [paymentButton setFrame: CGRectMake(4, registrantView.frame.origin.y + registrantView.frame.size.height + 8, paymentButton.frame.size.width, paymentButton.frame.size.height)];
        [scrollView setContentSize: CGSizeMake(scrollView.frame.size.width, paymentButton.frame.origin.y + paymentButton.frame.size.height + 8)];
    }else{
        [eventsTable setFrame: CGRectMake(4, eventsTable.frame.origin.y, eventsTable.frame.size.width, [eventsTable rowHeight] * [eventsTable numberOfRowsInSection: 0])];
        [cartTable setFrame: CGRectMake(4, cartTable.frame.origin.y, cartTable.frame.size.width, [cartTable rowHeight] * [cartTable numberOfRowsInSection: 0])];
        [baseCostHintLabel setFrame: CGRectMake(4, cartTable.frame.origin.y + cartTable.frame.size.height + 4, baseCostHintLabel.frame.size.width, baseCostHintLabel.frame.size.height)];
        [baseCostLabel setFrame: CGRectMake(baseCostLabel.frame.origin.x, baseCostHintLabel.frame.origin.y, baseCostLabel.frame.size.width, baseCostLabel.frame.size.height)];
        [processingFeeHintLabel setFrame: CGRectMake(4, baseCostLabel.frame.origin.y + baseCostLabel.frame.size.height + 4, processingFeeHintLabel.frame.size.width, processingFeeHintLabel.frame.size.height)];
        [processingFeeLabel setFrame: CGRectMake(processingFeeLabel.frame.origin.x, processingFeeHintLabel.frame.origin.y, processingFeeLabel.frame.size.width, processingFeeLabel.frame.size.height)];
        [totalHintLabel setFrame: CGRectMake(4, processingFeeLabel.frame.origin.y + processingFeeLabel.frame.size.height + 4, totalHintLabel.frame.size.width, totalHintLabel.frame.size.height)];
        [totalLabel setFrame: CGRectMake(totalLabel.frame.origin.x, totalHintLabel.frame.origin.y, totalLabel.frame.size.width, totalLabel.frame.size.height)];
        [registrationCartView setFrame: CGRectMake(4, eventsTable.frame.origin.y + eventsTable.frame.size.height + 8, registrationCartView.frame.size.width, totalLabel.frame.origin.y + totalLabel.frame.size.height + 8)];
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
    }else if(tableView == cartTable){
        static NSString *CartCellIdentifier = @"CartCellIdentifier";
        RaceSignUpCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartCellIdentifier];
        if(cell == nil){
            cell = [[RaceSignUpCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CartCellIdentifier];
        }
        
        NSDictionary *cartItem = [[cartDict objectForKey:@"Cart"] objectAtIndex: [indexPath row]];
        
        NSString *subitemsString = @"";
        for(NSString *si in [cartItem objectForKey:@"Subitems"]){
            subitemsString = [subitemsString stringByAppendingFormat:@", %@", si];
        }
        
        subitemsString = [subitemsString substringFromIndex: 2];
        
        [cell setInfo:[cartItem objectForKey:@"Info"] total:[cartItem objectForKey:@"TotalCost"] subitems:subitemsString];
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
    }else if(tableView == cartTable)
        return [[cartDict objectForKey:@"Cart"] count];
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)confirmPayment:(id)sender{
    if(!isFreeRace){
        if([[RSUModel sharedModel] paymentViewController] == nil){
            [[RSUModel sharedModel] setPaymentViewController: [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO]];
            [[[RSUModel sharedModel] paymentViewController] setDelegate: [RSUModel sharedModel]];
        }
        
        [dataDict setObject:[cartDict objectForKey:@"TotalCost"] forKey:@"TotalCost"];
        
        [[RSUModel sharedModel] setDataDict: dataDict];
        [self.navigationController pushViewController:[[RSUModel sharedModel] paymentViewController] animated:YES];
    }else{
        [dataDict setObject:@"$0.00" forKey:@"TotalCost"];
        
        [[RSUModel sharedModel] setDataDict: dataDict];
        
        void (^response)(RSUConnectionResponse, NSDictionary *) = ^(RSUConnectionResponse didSucceed, NSDictionary *data){
            [rli fadeOut];
            
            if(didSucceed == RSUSuccess){
                [dataDict setObject:data forKey:@"ConfirmationCodes"];
                
                RaceSignUpConfirmationViewController *rsucvc = [[RaceSignUpConfirmationViewController alloc] initWithNibName:@"RaceSignUpConfirmationViewController" bundle:Nil data:dataDict];
                [self.navigationController pushViewController:rsucvc animated:YES];
                [rsucvc release];
            }else if(didSucceed == RSUInvalidData && data != nil){
                if([data objectForKey:@"ErrorArray"] == nil){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error #%@: %@", [data objectForKey:@"ErrorCode"], [data objectForKey:@"ErrorMessage"]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [self.navigationController popToRootViewControllerAnimated: NO];
                }else{
                    NSString *errors = @"Errors: ";
                    for(NSString *error in [data objectForKey: @"ErrorArray"]){
                        errors = [errors stringByAppendingFormat:@"%@, ", error];
                    }
                    errors = [errors substringToIndex: [errors length] - 2];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errors delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [self.navigationController popToRootViewControllerAnimated: NO];
                }
            }else if(didSucceed == RSUInvalidData){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to register for race. Please try registration process again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [self.navigationController popToRootViewControllerAnimated: NO];
            }
        };
        
        [[rli label] setText: @"Registering..."];
        [rli fadeIn];
        [[RSUModel sharedModel] registerForRace:[dataDict objectForKey:@"RaceID"] withInfo:dataDict requestType:RSURegRegister response:response];
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
