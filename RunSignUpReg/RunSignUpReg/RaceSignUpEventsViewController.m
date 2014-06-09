//
//  RaceSignUpEventsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import "RaceSignUpEventsViewController.h"
#import "RaceSignUpGiveawayViewController.h"
#import "RaceSignUpQuestionsViewController.h"
#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpPaymentViewController.h"
#import "RaceSignUpEventTableViewCell.h"

@implementation RaceSignUpEventsViewController
@synthesize eventsTable;
@synthesize selectButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        selectedArray = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < [[dataDict objectForKey: @"events"] count]; x++){
            [selectedArray addObject: [NSNumber numberWithBool:NO]];
        }
        
        eventDateFormatter = [[NSDateFormatter alloc] init];
        
        self.title = @"Choose Event";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [selectButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [selectButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    if([eventsTable numberOfRowsInSection: 0] == 1){
        [[eventsTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [selectedArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool: YES]];
    }
}

- (IBAction)select:(id)sender{
    int totalSelected = 0;
    for(int x  = 0; x < [selectedArray count]; x++)
        if([[selectedArray objectAtIndex: x] boolValue])
            totalSelected++;
    
    if(totalSelected == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You haven't selected an event. Please select one or more and retry." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        NSMutableDictionary *newDataDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict copyItems:YES];
        NSMutableArray *mutableEventsArray = [[newDataDict objectForKey: @"events"] mutableCopy];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        for(int x = [selectedArray count] - 1; x >= 0; x--){
            if(![[selectedArray objectAtIndex: x] boolValue]){
                [mutableEventsArray removeObjectAtIndex: x];
            }else{
                BOOL registrationOpen = NO;
                for(int y = 0; y < [[[mutableEventsArray objectAtIndex: x] objectForKey:@"registration_periods"] count]; y++){
                    NSString *startDateString = [[[[mutableEventsArray objectAtIndex: x] objectForKey:@"registration_periods"] objectAtIndex: y] objectForKey: @"registration_opens"];
                    NSString *endDateString = [[[[mutableEventsArray objectAtIndex: x] objectForKey:@"registration_periods"] objectAtIndex: y] objectForKey: @"registration_closes"];
                    NSDate *startDate = [dateFormatter dateFromString: startDateString];
                    NSDate *endDate = [dateFormatter dateFromString: endDateString];
                    
                    if([[NSDate date] compare: startDate] != NSOrderedAscending && [[NSDate date] compare: endDate] != NSOrderedDescending)
                        registrationOpen = YES;
                }
                
                if(!registrationOpen){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more events are not currently open for registration." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
            }
        }
        
        [newDataDict setObject:mutableEventsArray forKey:@"events"];
        
        BOOL hasGiveaway = NO;
        for(NSDictionary *event in [newDataDict objectForKey: @"events"]){
            if([event objectForKey: @"giveaway"] != nil || [event objectForKey: @"giveaway-options"] != nil)
                hasGiveaway = YES;
        }
        
        if(hasGiveaway){
            RaceSignUpGiveawayViewController *rsugvc = [[RaceSignUpGiveawayViewController alloc] initWithNibName:@"RaceSignUpGiveawayViewController" bundle:nil data:newDataDict];
            [self.navigationController pushViewController:rsugvc animated:YES];
            [rsugvc release];
        }else{
            if([newDataDict objectForKey: @"questions"]){
                RaceSignUpQuestionsViewController *rsuqvc = [[RaceSignUpQuestionsViewController alloc] initWithNibName:@"RaceSignUpQuestionsViewController" bundle:nil data:newDataDict];
                [self.navigationController pushViewController:rsuqvc animated:YES];
                [rsuqvc release];
            }else if([newDataDict objectForKey: @"membership_settings"]){
                RaceSignUpMembershipsViewController *rsumvc = [[RaceSignUpMembershipsViewController alloc] initWithNibName:@"RaceSignUpMembershipsViewController" bundle:nil data:newDataDict];
                [self.navigationController pushViewController:rsumvc animated:YES];
                [rsumvc release];
            }else{
                RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:newDataDict];
                [self.navigationController pushViewController:rsupvc animated:YES];
                [rsupvc release];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL oppositeBool = ![[selectedArray objectAtIndex: indexPath.row] boolValue];
    [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool: oppositeBool]];
    if(oppositeBool)
        [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
    else
        [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryNone];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RaceSignUpEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[RaceSignUpEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
                
                if([openDate compare: [NSDate date]] == NSOrderedAscending && [closeDate compare: [NSDate date]] == NSOrderedDescending)
                    actualRegPeriod = regPeriod;
            }
            
            break;
        }
    }
    
    if(actualEvent && actualRegPeriod){
        [cell setPrice:[actualRegPeriod objectForKey: @"race_fee"] price2:[actualRegPeriod objectForKey: @"processing_fee"]];
        [[cell nameLabel] setText: [actualEvent objectForKey: @"name"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    NSLog(@"Schedevreg: %i", scheduledEventsWithOpenReg);
    return scheduledEventsWithOpenReg;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
