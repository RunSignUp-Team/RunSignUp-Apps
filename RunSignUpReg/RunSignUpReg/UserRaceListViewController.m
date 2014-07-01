//
//  UserRaceListViewController.m
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

#import "UserRaceListViewController.h"
#import "RSUModel.h"

@implementation UserRaceListViewController
@synthesize table;
@synthesize raceList;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Race List";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    [[rli label] setText:@"Fetching list..."];
    [self.view addSubview: rli];
    [rli release];
    
    void (^response)(NSArray *) = ^(NSArray *list){
        self.raceList = list;
        [table reloadData];
        [rli fadeOut];
    };
    
    self.raceList = nil;
    [rli fadeIn];
    [[RSUModel sharedModel] retrieveUserRaceList: response];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 290, 20)];
        [nameLabel setFont: [UIFont boldSystemFontOfSize:18.0f]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTag: 12];
        [cell addSubview: nameLabel];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, 200, 16)];
        [dateLabel setFont: [UIFont systemFontOfSize:14.0f]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setTextColor: [UIColor lightGrayColor]];
        [dateLabel setTag: 13];
        [cell addSubview: dateLabel];
    }
    if(raceList == nil){
        [[cell textLabel] setText: @"No races found. Please retry."];
        [(UILabel *)[cell viewWithTag:12] setText:@""];
        [(UILabel *)[cell viewWithTag:13] setText:@""];
    }else{
        [[cell textLabel] setText:@""];
        [(UILabel *)[cell viewWithTag:12] setText: [[raceList objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [(UILabel *)[cell viewWithTag:13] setText: [[raceList objectAtIndex:indexPath.row] objectForKey:@"next_date"]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [raceList count];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
