//
//  RaceResultsEventViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import "RaceResultsEventViewController.h"
#import "RaceResultsEventTableViewCell.h"

@implementation RaceResultsEventViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Event Results";
    }
    return self;
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
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, headerHeight / 2 - (fontSize + 2.0f) / 2.0f, [[UIScreen mainScreen] bounds].size.width - 8, fontSize + 2.0f)];
    [headerLabel setFont: [UIFont systemFontOfSize: fontSize]];
    [headerLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
    [headerLabel setText:@"  Place     Bib            Name            Sex     Time   Pace    Age"];
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
    
    // Fake some data
    
    NSArray *fakeNames = [[NSArray alloc] initWithObjects:@"William", @"Arnold", @"Robert", @"Stephen", @"Andrew", @"Ryan", @"Christopher", @"Alex", nil];
    NSArray *fakeLNames = [[NSArray alloc] initWithObjects:@"Connolly", @"Palmer", @"Bickel", @"Sigwary", @"Burke", @"Snell", @"Schweikert", @"Rider", nil];
    
    [[cell placeLabel] setText: [NSString stringWithFormat:@"%i", rand() % 999]];
    [[cell bibLabel] setText: [NSString stringWithFormat:@"%i", rand() % 9999]];
    [[cell firstNameLabel] setText: [fakeNames objectAtIndex: rand() % 8]];
    [[cell lastNameLabel] setText: [fakeLNames objectAtIndex: rand() % 8]];
    [[cell genderLabel] setText: @"M"];
    [[cell timeLabel] setText: [NSString stringWithFormat:@"%i:%i", rand() % 15 + 15, rand() % 49 + 10]];
    [[cell paceLabel] setText: [NSString stringWithFormat:@"5:%i", rand() % 40 + 15]];
    [[cell ageLabel] setText: [NSString stringWithFormat:@"%i", rand() % 30 + 20]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 199;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
