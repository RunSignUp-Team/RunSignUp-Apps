//
//  RaceSignUpEventsViewController.m
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

#import "RaceSignUpEventsViewController.h"
#import "RaceSignUpWaiverViewController.h"
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
        
        if([dataDict objectForKey: @"chosenRegistration"]){
            int chosenRegistration = [[dataDict objectForKey:@"chosenRegistration"] intValue];
            if(chosenRegistration >= 0 && chosenRegistration < [selectedArray count]){
                [selectedArray replaceObjectAtIndex:chosenRegistration withObject:[NSNumber numberWithBool: YES]];
            }
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
    //[selectButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    [[selectButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:18]];
    
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
        
        RaceSignUpWaiverViewController *rswvc = [[RaceSignUpWaiverViewController alloc] initWithNibName:@"RaceSignUpWaiverViewController" bundle:nil data:newDataDict];
        [self.navigationController pushViewController:rswvc animated:YES];
        [rswvc release];
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
                
                actualRegPeriod = nil;
                
                if([openDate compare: [NSDate date]] == NSOrderedAscending && [closeDate compare: [NSDate date]] == NSOrderedDescending)
                    actualRegPeriod = regPeriod;
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
        [[cell nameLabel] setText: [actualEvent objectForKey: @"name"]];
        
        if([[selectedArray objectAtIndex: indexPath.row] boolValue])
            [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType: UITableViewCellAccessoryNone];
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
