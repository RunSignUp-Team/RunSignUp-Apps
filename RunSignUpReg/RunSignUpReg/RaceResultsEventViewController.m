//
//  RaceResultsEventViewController.m
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

#import "RaceResultsEventViewController.h"
#import "RaceResultsEventTableViewCell.h"
#import "RaceResultsEventDetailsViewController.h"
#import "RSUModel.h"

@implementation RaceResultsEventViewController
@synthesize table;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Event Results";
        
        dataDict = data;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
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

    [rli fadeIn];
    
    void (^response)(NSArray *) = ^(NSArray *resultsArray){
        NSLog(@"%@", resultsArray);
        results = resultsArray;
        
        [rli fadeOut];
        [table reloadData];
    };
    
    [[RSUModel sharedModel] retrieveEventResultsWithRaceID:[dataDict objectForKey:@"race_id"] eventID:[dataDict objectForKey:@"event_id"] resultSetID:[dataDict objectForKey:@"individual_result_set_id"] response:response];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    float headerHeight = 44.0f;
    
    UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [table frame].size.width, headerHeight)];
    [header setBackgroundColor: [UIColor colorWithRed:215/255.0f green:235/255.0f blue:241/255.0f alpha:1.0f]];
    [header.layer setBorderColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f].CGColor];
    [header.layer setBorderWidth: 1.0f];
    
    int widths[] = {40, 40, 86, 38, 40, 37, 32};
    int cumWidth = 4;
    for(int x = 0; x <= 7; x++){
        UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(cumWidth, 0, 1, headerHeight)];
        [divider setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
        [header addSubview: divider];
        [divider release];
        
        cumWidth += widths[x];
    }
    
    float fontSize = 11.0f;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, headerHeight / 2 - (fontSize + 2.0f) / 2.0f, [[UIScreen mainScreen] bounds].size.width - 8, fontSize + 4.0f)];
    [headerLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
    [headerLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
    [headerLabel setText:@"  Place       Bib              Name             Sex      Time     Pace    Age"];
    // I'm lazy and did not feel like laying out labels individually ^
    [header addSubview: headerLabel];
    
    return header;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ResultsCellIdentifier";
    RaceResultsEventTableViewCell *cell = (RaceResultsEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[RaceResultsEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([results count] > 0){
        [[cell placeLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"place"]];
        [[cell bibLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"bib"]];
        [[cell firstNameLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"first_name"]];
        [[cell lastNameLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"last_name"]];
        [[cell genderLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"gender"]];
        [[cell timeLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"clock_time"]];
        [[cell paceLabel] setText: @""];
        [[cell ageLabel] setText: [[results objectAtIndex: [indexPath row]] objectForKey: @"age"]];
        [[cell textLabel] setText: @""];
        [cell showDividers];
    }else{
        [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:18]];
        [[cell textLabel] setText: @"No Results Found"];
        [cell hideDividers];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RaceResultsEventDetailsViewController *rredvc = [[RaceResultsEventDetailsViewController alloc] initWithNibName:@"RaceResultsEventDetailsViewController" bundle:nil data:[results objectAtIndex: [indexPath row]]];
    [self.navigationController pushViewController:rredvc animated:YES];
    [rredvc release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([results count] > 0)
        return [results count];
    else
        return 1;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
