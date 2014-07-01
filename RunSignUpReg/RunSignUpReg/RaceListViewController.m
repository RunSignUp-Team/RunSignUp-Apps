//
//  RaceListViewController.m
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

#import "RaceListViewController.h"
#import "RaceSearchViewController.h"
#import "RaceDetailsViewController.h"
#import "RaceTableViewCell.h"
#import "RSUModel.h"

@implementation RaceListViewController
@synthesize table;
@synthesize searchParams;
@synthesize raceList;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Races";
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];
        [[rli label] setText: @"Fetching List..."];
        [self.view addSubview: rli];
        [rli release];
        
        self.searchParams = nil;
        moreResultsToRetrieve = YES;
        
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0, 0 - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        [refreshHeaderView setDelegate: self];
        [self.table addSubview: refreshHeaderView];
        [refreshHeaderView release];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    [table setSeparatorColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]];
    [self retrieveRaceList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (void)retrieveRaceList{
    [rli fadeIn];
    void (^response)(NSArray *) = ^(NSArray *list){
        moreResultsToRetrieve = YES;
        if(list == nil || [list count] < 10)
            moreResultsToRetrieve = NO;
        
        self.raceList = list;
        [rli fadeOut];
        [table reloadData];
        [self doneLoadingTableViewData:YES];
    };
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (void)retrieveRaceListAndAppend{
    [rli fadeIn];
    void (^response)(NSArray *) = ^(NSArray *list){
        if(list == nil || [list count] == 0){
            // Page retrieval returned empty - reset page number
            moreResultsToRetrieve = NO;
            int currentPage = [[searchParams objectForKey:@"page"] intValue];
            [searchParams setObject:[NSString stringWithFormat:@"%i", MAX(currentPage - 1, 0)] forKey:@"page"];
        }else if([list count] < 10)
            moreResultsToRetrieve = NO;
        
        int oldCount = [raceList count];
        NSMutableArray *newRaceList = [[NSMutableArray alloc] initWithArray:raceList];
        [newRaceList addObjectsFromArray: list];
        self.raceList = newRaceList;
        [rli fadeOut];
        [table reloadData];
        
        if([raceList count] != oldCount){
            UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldCount inSection:0]];
            [cell setAlpha: 0.0f];
            [UIView beginAnimations:@"Cell Fade" context:nil];
            [UIView setAnimationDuration: 0.75f];
            [cell setAlpha: 1.0f];
            [UIView commitAnimations];
        }
            
        [self doneLoadingTableViewData:NO];
    };
    [[RSUModel sharedModel] retrieveRaceListWithParams:searchParams response:response];
}

- (IBAction)showSearchParams:(id)sender{
    RaceSearchViewController *rsvc = [[RaceSearchViewController alloc] initWithNibName:@"RaceSearchViewController" bundle:nil];
    [rsvc setDelegate: self];
    [self.navigationController pushViewController:rsvc animated:YES];
    [rsvc release];
}

- (IBAction)clearSearchParams:(id)sender{
    [self.searchParams release];
    self.searchParams = nil;
    [self retrieveRaceList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [raceList count]){
        static NSString *RaceCellIdentifier = @"RaceCellIdentifier";

        RaceTableViewCell *cell = (RaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RaceCellIdentifier];
        if(cell == nil){
            cell = [[RaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RaceCellIdentifier];
        }
        
        [[cell nameLabel] setText: [[raceList objectAtIndex: indexPath.row] objectForKey: @"name"]];
        [[cell dateLabel] setText: [[raceList objectAtIndex: indexPath.row] objectForKey: @"next_date"]];
        [[cell locationLabel] setText: [[RSUModel sharedModel] addressLine2FromAddress: [[raceList objectAtIndex: indexPath.row] objectForKey: @"address"]]];
        
        NSString *htmlString = [[raceList objectAtIndex: indexPath.row] objectForKey: @"description"];
        
        NSRange r;
        while((r = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            htmlString = [htmlString stringByReplacingCharactersInRange:r withString:@""];
        }
        
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h1>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h1>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h2>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h2>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h3>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h3>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h4>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h4>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<h5>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</h5>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<span>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</b>" withString:@""];

        [[cell descriptionLabel] setText: htmlString];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if(moreResultsToRetrieve){
            [[cell textLabel] setText:@"Load More..."];
            [[cell textLabel] setTextColor: [UIColor blackColor]];
            [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
        }else{
            [[cell textLabel] setText:@"All Results Loaded"];
            [[cell textLabel] setTextColor: [UIColor lightGrayColor]];
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
        }
        [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [raceList count]){
        RaceDetailsViewController *rdvc = [[RaceDetailsViewController alloc] initWithNibName:@"RaceDetailsViewController" bundle:nil data:[raceList objectAtIndex: indexPath.row]];
        [self.navigationController pushViewController:rdvc animated:YES];
        [rdvc release];
    }else if(moreResultsToRetrieve){
        if([searchParams objectForKey:@"page"]){
            int currentPage = [[searchParams objectForKey:@"page"] intValue];
            [searchParams setObject:[NSString stringWithFormat:@"%i", currentPage + 1] forKey:@"page"];
        }else if(searchParams){
            [searchParams setObject:@"2" forKey:@"page"];
            // No page value was listed, assumed to be 1. Increment to 2^
        }else{
            searchParams = [[NSMutableDictionary alloc] init];
            [searchParams setObject:@"2" forKey:@"page"];
        }
        [self retrieveRaceListAndAppend];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    int headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    //[header setBackgroundColor: [UIColor colorWithRed:0.5f green:0.6863f blue:0.8431f alpha:1.0f]];
    [header setBackgroundColor: [refreshHeaderView backgroundColor]];
    
    UIImageView *cancelIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CancelSearch.png"]];
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search.png"]];
    [cancelIcon setFrame: CGRectMake(4, headerHeight / 2 - 10, 16, 16)];
    [searchIcon setFrame: CGRectMake(4, headerHeight / 2 - 10, 16, 16)];
    
    UILabel *racesLabel = [[UILabel alloc] initWithFrame: CGRectMake(6, 2, 100, headerHeight - 4)];
    [racesLabel setText: @"Races"];
    [racesLabel setBackgroundColor: [UIColor clearColor]];
    [racesLabel setFont: [UIFont boldSystemFontOfSize: 18.0f]];
    [racesLabel setTextColor: [UIColor darkGrayColor]];
    [header addSubview: racesLabel];
    
    UILabel *clearSearchLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 2, 118, headerHeight - 4)];
    [clearSearchLabel setBackgroundColor: [UIColor colorWithRed:0.3843f green:0.5529 blue:0.7176f alpha:1.0f]];
    [clearSearchLabel setText: @"Clear Search"];
    [clearSearchLabel setTextAlignment: NSTextAlignmentRight];
    [clearSearchLabel setFont: [UIFont systemFontOfSize: 16.0f]];
    [clearSearchLabel setTextColor: [UIColor whiteColor]];
    [clearSearchLabel setUserInteractionEnabled: YES];
    [clearSearchLabel addSubview: cancelIcon];
    [header addSubview: clearSearchLabel];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearSearchParams:)];
    [clearSearchLabel addGestureRecognizer: gesture];
    [gesture release];
    [clearSearchLabel release];
    
    UILabel *searchLabel = [[UILabel alloc] initWithFrame: CGRectMake(192, 2, 124, headerHeight - 4)];
    [searchLabel setBackgroundColor: [UIColor colorWithRed:0.3843f green:0.5529 blue:0.7176f alpha:1.0f]];
    [searchLabel setText: @"Search Races"];
    [searchLabel setTextAlignment: NSTextAlignmentRight];
    [searchLabel setFont: [UIFont systemFontOfSize: 16.0f]];
    [searchLabel setTextColor: [UIColor whiteColor]];
    [searchLabel setUserInteractionEnabled: YES];
    [searchLabel addSubview: searchIcon];
    [header addSubview: searchLabel];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchParams:)];
    [searchLabel addGestureRecognizer: gesture2];
    [gesture2 release];
    [searchLabel release];
    
    //[cancelIcon release];
    //[searchIcon release];
    
    UIView *separator = [[UIView alloc] initWithFrame: CGRectMake(0, headerHeight, 320, 1)];
    [separator setBackgroundColor: [UIColor colorWithRed:0.0f green:0.5804f blue:0.8f alpha:1.0f]];
    [header addSubview: separator];
    return header;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([raceList count] != 0){
        if(indexPath.row < [raceList count])
            return 200;
        else
            return 100;
    }else{
        return 200;
    }
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [raceList count] + 1; // + 1 for "Load More" button
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)reloadTableViewDataSource{
    reloading = YES;
    [searchParams setObject:@"1" forKey:@"page"]; // Only reload page 1 if refreshing
    [self retrieveRaceList];
}

- (void)doneLoadingTableViewData:(BOOL)scroll{
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    if(scroll)
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
