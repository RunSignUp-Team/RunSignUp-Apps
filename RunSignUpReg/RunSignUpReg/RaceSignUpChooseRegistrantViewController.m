//
//  RaceSignUpChooseRegistrantViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/19/13.
//
//

#import "RaceSignUpChooseRegistrantViewController.h"
#import "RSUModel.h"
#import "SignUpViewController.h"
#import "RaceSignUpWaiverViewController.h"

@implementation RaceSignUpChooseRegistrantViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        
        self.title = @"Choose Registrant";
    }
    return self;
}

- (void)didSignInEmail:(NSString *)email{
    [table reloadData];
}

- (void)didSignUpWithDictionary:(NSDictionary *)dict{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[RSUModel sharedModel] signedIn]){
        if(indexPath.row == 0){ // Register me
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantMe];
            RaceSignUpWaiverViewController *rswvc = [[RaceSignUpWaiverViewController alloc] initWithNibName:@"RaceSignUpWaiverViewController" bundle:nil data:dataDict];
            [self.navigationController pushViewController:rswvc animated:YES];
            [rswvc release];
        }else if(indexPath.row == 1){ // Register someone else
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantSomeoneElse];
            
        }else{ // Register a secondary user
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantSecondary];
            
        }
    }else{
        if(indexPath.row == 0){ // Sign in
            SignInViewController *sivc = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            [sivc setDelegate: self];
            [self presentViewController:sivc animated:YES completion:nil];
            [sivc release];
        }else if(indexPath.row == 1){ // New user
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantNewUser];
            SignUpViewController *suvc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
            [suvc setSignUpMode: RSUSignUpSomeoneElse];
            [suvc setDelegate: self];
            [self presentViewController:suvc animated:YES completion:nil];
            [suvc release];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([[RSUModel sharedModel] signedIn]){
        if(indexPath.row == 0){
            [[cell textLabel] setText: @"Register Me"];
        }else if(indexPath.row == 1){
            [[cell textLabel] setText: @"Register Someone Else"];
        }else{
            NSDictionary *user = [[[[RSUModel sharedModel] currentUser] objectForKey:@"SecondaryUsers"] objectAtIndex: indexPath.row - 2];
            [[cell textLabel] setText: [NSString stringWithFormat: @"Register %@ %@", [user objectForKey: @"FName"], [user objectForKey: @"LName"]]];
        }
    }else{
        if(indexPath.row == 0){
            [[cell textLabel] setText: @"Sign In"];
        }else if(indexPath.row == 1){
            [[cell textLabel] setText: @"Register New User"];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[RSUModel sharedModel] signedIn])
        return 2 + [[[[RSUModel sharedModel] currentUser] objectForKey:@"SecondaryUsers"] count];
    else
        return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
