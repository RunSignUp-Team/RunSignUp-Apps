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
@synthesize results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Event Results";
        
        dataDict = data;
        
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

    [rli fadeIn];
    
    page = 1;
    
    [self retrieveResults];
}

- (void)retrieveResults{
    void (^response)(NSArray *) = ^(NSArray *resultsArray){
        self.results = resultsArray;
        
        if([resultsArray count] == 50)
            moreResultsToRetrieve = YES;
        else
            moreResultsToRetrieve = NO;
        
        [rli fadeOut];
        [table reloadData];
    };
    
    [[RSUModel sharedModel] retrieveEventResultsWithRaceID:[dataDict objectForKey:@"race_id"] eventID:[dataDict objectForKey:@"event_id"] resultSetID:[dataDict objectForKey:@"individual_result_set_id"] page:page response:response];
}

- (void)retrieveResultsAndAppend{
    void (^response)(NSArray *) = ^(NSArray *resultsArray){
        if([resultsArray count] == 0){
            moreResultsToRetrieve = NO;
        }else{
            if([resultsArray count] == 50)
                moreResultsToRetrieve = YES;
            else
                moreResultsToRetrieve = NO;
            
            NSMutableArray *newResults = [[NSMutableArray alloc] initWithArray:results];
            [newResults addObjectsFromArray: resultsArray];
            self.results = newResults;
            
            [rli fadeOut];
            [table reloadData];
        }
    };
    
    [[RSUModel sharedModel] retrieveEventResultsWithRaceID:[dataDict objectForKey:@"race_id"] eventID:[dataDict objectForKey:@"event_id"] resultSetID:[dataDict objectForKey:@"individual_result_set_id"] page:page response:response];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        float headerHeight = [self tableView:tableView heightForHeaderInSection:section];
        
        UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [table frame].size.width, headerHeight)];
        [header setBackgroundColor: [UIColor colorWithRed:215/255.0f green:235/255.0f blue:241/255.0f alpha:1.0f]];
        [header.layer setBorderColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f].CGColor];
        [header.layer setBorderWidth: 1.0f];
        
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        // int widths[] = {40, 40, 86, 38, 40, 37, 31};   // integer widths, changed to floats to accept larger screen sizes
        float widths[] = {0.125f, 0.125f, 0.26875f, 0.11875f, 0.125f, 0.1125f, 0.1125f}; // floats derived from above divided by 320 (old iphone screen width)
        NSArray *headers = @[@"Place",@"Bib",@"Name",@"Sex",@"Time",@"Pace",@"Age"];
        int cumWidth = 4;
        float fontSize = 11.0f;
        
        for(int x = 0; x <= 7; x++){
            UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(cumWidth, 0, 1, headerHeight)];
            [divider setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
            [header addSubview: divider];
            [divider release];
            
            if(x < 7){
                UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(cumWidth, 0, widths[x] * (float)screenWidth, headerHeight)];
                [headerLabel setFont: [UIFont fontWithName:@"OpenSans" size:fontSize]];
                [headerLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
                [headerLabel setText: [headers objectAtIndex:x]];
                [headerLabel setTextAlignment: NSTextAlignmentCenter];
                [header addSubview: headerLabel];
                [headerLabel release];
            }
                
            cumWidth += widths[x] * screenWidth;
        }
        
        return header;
    }
    return nil;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 44;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *CellIdentifier = @"ResultsCellIdentifier";

        RaceResultsEventTableViewCell *cell = (RaceResultsEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[RaceResultsEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
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
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
        [[cell textLabel] setTextColor: [UIColor colorWithRed:64/255.0 green:114/255.0 blue:145/255.0 alpha:1.0]];
        
        if(moreResultsToRetrieve){
            [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:16]];
            [[cell textLabel] setText: @"Load More Results..."];
        }else if([results count]){
            [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:16]];
            [[cell textLabel] setText: @"All Results Loaded"];
        }else{
            [[cell textLabel] setFont: [UIFont fontWithName:@"OpenSans" size:16]];
            [[cell textLabel] setText: @"No Results Found"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RaceResultsEventDetailsViewController *rredvc = [[RaceResultsEventDetailsViewController alloc] initWithNibName:@"RaceResultsEventDetailsViewController" bundle:nil data:[results objectAtIndex: [indexPath row]]];
        [self.navigationController pushViewController:rredvc animated:YES];
        [rredvc release];
    }else{
        if(moreResultsToRetrieve){
            page++;
            [self retrieveResultsAndAppend];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 44;
    else
        return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [results count];
    }else{
        return 1;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
