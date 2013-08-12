//
//  RaceSignUpGiveawayViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import "RaceSignUpGiveawayViewController.h"
#import "RaceSignUpGiveawayTableViewCell.h"
#import "RaceSignUpPaymentViewController.h"

@implementation RaceSignUpGiveawayViewController
@synthesize giveawayTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        dataDict = data;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath section] != [[dataDict objectForKey:@"Events"] count]){
        static NSString *GiveawayCellIdentifier = @"GiveawayCellIdentifier";
        RaceSignUpGiveawayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GiveawayCellIdentifier];
        if(cell == nil){
            cell = [[RaceSignUpGiveawayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GiveawayCellIdentifier];
        }
        
        [cell setGiveawayOptions: [[[dataDict objectForKey: @"Events"] objectAtIndex: [indexPath section]] objectForKey: @"EventGiveawayOptions"]];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
            UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
            UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
            UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            
            UIButton *chooseButton = [UIButton buttonWithType: UIButtonTypeCustom];
            [chooseButton addTarget:self action:@selector(chooseGiveaways:) forControlEvents:UIControlEventTouchUpInside];
            [chooseButton setFrame: CGRectMake(4, 4, 312, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 8)];
            [chooseButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
            [chooseButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
            [chooseButton setTitle:@"Choose Giveaways" forState:UIControlStateNormal];
            [[chooseButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 18.0f]];
            
            [[cell contentView] addSubview: chooseButton];
            [chooseButton release];
        }
        
        return cell;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section] != [[dataDict objectForKey:@"Events"] count])
        return [tableView rowHeight];
    else
        return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section != [[dataDict objectForKey:@"Events"] count]){
        if([[[[dataDict objectForKey: @"Events"] objectAtIndex: section] objectForKey: @"EventGiveawayOptions"] count] != 0)
            return 1;
        else
            return 0;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section != [[dataDict objectForKey:@"Events"] count]){
        NSString *giveawayOption = [[[dataDict objectForKey: @"Events"] objectAtIndex: section] objectForKey: @"Giveaway"];
        if(giveawayOption == nil)
            giveawayOption = @"No giveaway";
        return [NSString stringWithFormat:@"%@ - %@", [[[dataDict objectForKey:@"Events"] objectAtIndex: section] objectForKey: @"Name"], giveawayOption];
    }else
        return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[dataDict objectForKey: @"Events"] count] + 1;
}

- (IBAction)chooseGiveaways:(id)sender{
    for(int x = 0; x < [[dataDict objectForKey:@"Events"] count]; x++){
        if(x != [[dataDict objectForKey: @"Events"] count]){
            RaceSignUpGiveawayTableViewCell *cell = (RaceSignUpGiveawayTableViewCell *)[giveawayTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:x]];
            NSString *giveawayID = [cell getSelectedGiveawayID];
            if(giveawayID)
                [[[dataDict objectForKey: @"Events"] objectAtIndex: x] setObject:giveawayID forKey:@"GiveawayOptionID"];
        }
    }
    
    RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rsupvc animated:YES];
    [rsupvc release];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
