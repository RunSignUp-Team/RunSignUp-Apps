//
//  SettingsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/16/14.
//
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize table;
@synthesize autoSignInSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        for(UIView *subView in [self.view subviews]){
            CGRect frame = [subView frame];
            frame.origin.y += 20;
            [subView setFrame: frame];
        }
    }
    [autoSignInSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoSignIn"]];
}

- (IBAction)autoSignInChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:autoSignInSwitch.on forKey:@"AutoSignIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setText: [[NSArray arrayWithObjects:@"Automatically Sign In:", nil] objectAtIndex:indexPath.row]];
    
    switch(indexPath.row){
        case 0:
            [autoSignInSwitch setFrame: CGRectMake(250, 7, 0, 0)];
            [cell addSubview: autoSignInSwitch];
            break;
        default:
            break;
    }
    
    return cell;
}

- (IBAction)done:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Settings";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
