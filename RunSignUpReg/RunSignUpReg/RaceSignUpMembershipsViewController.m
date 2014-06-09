//
//  RaceSignUpMembershipsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/9/14.
//
//

#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpMembershipsTableViewCell.h"

@implementation RaceSignUpMembershipsViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        
        self.title = @"Memberships";
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] != [[dataDict objectForKey:@"membership_settings"] count]){
        RaceSignUpMembershipsTableViewCell *cell = [[RaceSignUpMembershipsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [[cell textLabel] setText: [[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"membership_setting_name"]];
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
            UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
            UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
            UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
            
            UIButton *answerButton = [UIButton buttonWithType: UIButtonTypeCustom];
            //[answerButton addTarget:self action:@selector(answerQuestions:) forControlEvents:UIControlEventTouchUpInside];
            [answerButton setFrame: CGRectMake(4, 4, 312, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 8)];
            [answerButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
            [answerButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
            [answerButton setTitle:@"Continue" forState:UIControlStateNormal];
            [[answerButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 18.0f]];
            
            [[cell contentView] addSubview: answerButton];
            [answerButton release];
        }
        
        return cell;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dataDict objectForKey: @"membership_settings"] count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
