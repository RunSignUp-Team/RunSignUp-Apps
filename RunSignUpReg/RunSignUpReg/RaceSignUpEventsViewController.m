//
//  RaceSignUpEventsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import "RaceSignUpEventsViewController.h"
#import "RaceSignUpGiveawayViewController.h"
#import "RaceSignUpEventTableViewCell.h"

@implementation RaceSignUpEventsViewController
@synthesize eventsTable;
@synthesize selectButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        selectedArray = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < [[dataDict objectForKey: @"Events"] count]; x++){
            [selectedArray addObject: [NSNumber numberWithBool:NO]];
        }
        
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
        NSMutableArray *mutableEventsArray = [[newDataDict objectForKey: @"Events"] mutableCopy];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        for(int x = [selectedArray count] - 1; x >= 0; x--){
            if(![[selectedArray objectAtIndex: x] boolValue]){
                [mutableEventsArray removeObjectAtIndex: x];
            }else{
                BOOL registrationOpen = NO;
                for(int y = 0; y < [[[mutableEventsArray objectAtIndex: x] objectForKey:@"EventRegistrationPeriods"] count]; y++){
                    NSString *startDateString = [[[[mutableEventsArray objectAtIndex: x] objectForKey:@"EventRegistrationPeriods"] objectAtIndex: y] objectForKey: @"RegistrationOpens"];
                    NSString *endDateString = [[[[mutableEventsArray objectAtIndex: x] objectForKey:@"EventRegistrationPeriods"] objectAtIndex: y] objectForKey: @"RegistrationCloses"];
                    NSDate *startDate = [dateFormatter dateFromString: startDateString];
                    NSDate *endDate = [dateFormatter dateFromString: endDateString];
                    
                    NSLog(@"%@ %@ %@", startDate, [NSDate date], endDate);
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
        
        [newDataDict setObject:mutableEventsArray forKey:@"Events"];
        
        RaceSignUpGiveawayViewController *rsugvc = [[RaceSignUpGiveawayViewController alloc] initWithNibName:@"RaceSignUpGiveawayViewController" bundle:nil data:newDataDict];
        [self.navigationController pushViewController:rsugvc animated:YES];
        [rsugvc release];
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
    
    NSDictionary *firstRegPeriod = [[[[dataDict objectForKey: @"Events"] objectAtIndex: indexPath.row] objectForKey: @"EventRegistrationPeriods"] objectAtIndex: 0];
    [cell setPrice:[firstRegPeriod objectForKey: @"RegistrationFee"] price2:[firstRegPeriod objectForKey: @"RegistrationProcessingFee"]];
    [[cell nameLabel] setText: [[[dataDict objectForKey:@"Events"] objectAtIndex: indexPath.row] objectForKey: @"Name"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dataDict objectForKey:@"Events"] count];
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
