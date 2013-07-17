//
//  RaceSignUpEventsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import "RaceSignUpEventsViewController.h"
#import "RaceSignUpTShirtViewController.h"
#import "RaceSignUpEventTableViewCell.h"

@implementation RaceSignUpEventsViewController
@synthesize eventsTable;
@synthesize selectButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
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
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [selectButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [selectButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
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
        
        // Pass on selection info >>
        
        RaceSignUpTShirtViewController *rsutvc = [[RaceSignUpTShirtViewController alloc] initWithNibName:@"RaceSignUpTShirtViewController" bundle:nil data:dataDict];
        [self.navigationController pushViewController:rsutvc animated:YES];
        [rsutvc release];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL oppositeBool = ![[selectedArray objectAtIndex: indexPath.row] boolValue];
    [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool: oppositeBool]];
    NSLog(@"%@", selectedArray);
    if(oppositeBool)
        [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
    else
        [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryNone];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
