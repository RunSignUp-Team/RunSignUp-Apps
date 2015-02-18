//
//  RaceResultsViewController.m
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

#import "RaceResultsViewController.h"
#import "RaceResultsEventViewController.h"
#import "RSUModel.h"

@implementation RaceResultsViewController
@synthesize table;
@synthesize dataDict;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataDict = data;
        self.title = @"Result Sets";
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:[[UIScreen mainScreen] bounds].size.width / 2 - 80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching Results..."];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview: rli];
    [rli release];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    events = [[NSMutableArray alloc] init];
    
    [rli fadeIn];
    retrieveCalls = [[dataDict objectForKey:@"events"] count];
    int index = 0;
    
    for(NSDictionary *event in [dataDict objectForKey:@"events"]){
        void (^response)(NSArray *) = ^(NSArray *resultSets){
            if([resultSets count] > 0){
                NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
                [eventDict setObject:[event objectForKey:@"name"] forKey:@"name"];
                [eventDict setObject:[event objectForKey:@"event_id"] forKey:@"event_id"];
                [eventDict setObject:resultSets forKey:@"result_sets"];
                
                [events addObject: eventDict];
            }
            
            NSLog(@"Recieved index %i info %@", index, resultSets);

            retrieveCalls--;
            if(retrieveCalls <= 0){
                [rli fadeOut];
                NSLog(@"Events: %@", events);
                [table reloadData];
            }
        };
        
        [[RSUModel sharedModel] retrieveEventResultSetsWithRaceID:[dataDict objectForKey:@"race_id"] eventID:[event objectForKey:@"event_id"] response:response];
        index++;
    }
}

- (NSDictionary *)eventDictFromEventID:(NSString *)eventID{
    for(NSDictionary *event in [dataDict objectForKey: @"events"]){
        if([[event objectForKey: @"event_id"] isEqualToString: eventID])
            return event;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ResultsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:18]];
    [[cell textLabel] setText: [[[[events objectAtIndex: [indexPath section]] objectForKey:@"result_sets"] objectAtIndex: [indexPath row]] objectForKey:@"individual_result_set_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *resultSetID = [[[[events objectAtIndex: [indexPath section]] objectForKey:@"result_sets"] objectAtIndex: [indexPath row]] objectForKey:@"individual_result_set_id"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[dataDict objectForKey:@"race_id"], @"race_id", [[[dataDict objectForKey:@"events"] objectAtIndex: [indexPath section]] objectForKey:@"event_id"], @"event_id", resultSetID, @"individual_result_set_id", nil];
    RaceResultsEventViewController *rrevc = [[RaceResultsEventViewController alloc] initWithNibName:@"RaceResultsEventViewController" bundle:nil data: data];
    [self.navigationController pushViewController:rrevc animated:YES];
    [rrevc release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [events count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *event = [self eventDictFromEventID: [[events objectAtIndex: section] objectForKey: @"event_id"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy hh:mm"];
    NSDate *startTimeDate = [formatter dateFromString: [event objectForKey: @"start_time"]];
    [formatter setDateFormat: @"yyyy"];
    NSString *yearString = [formatter stringFromDate: startTimeDate];
    
    return [NSString stringWithFormat: @"%@ %@", [[events objectAtIndex: section] objectForKey:@"name"], yearString];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[events objectAtIndex: section] objectForKey:@"result_sets"] count];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
