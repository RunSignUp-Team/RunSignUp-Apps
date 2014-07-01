//
//  RaceSignUpChooseRegistrantViewController.m
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

#import "RaceSignUpChooseRegistrantViewController.h"
#import "RSUModel.h"
#import "SignUpViewController.h"
#import "RaceSignUpEventsViewController.h"

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
    [dataDict setObject:dict forKey:@"registrant"];
    
    RaceSignUpEventsViewController *rsuevc = [[RaceSignUpEventsViewController alloc] initWithNibName:@"RaceSignUpEventsViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rsuevc animated:YES];
    [rsuevc release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[RSUModel sharedModel] signedIn]){
        if(indexPath.row == 0){ // Register me
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantMe];
            
            RaceSignUpEventsViewController *rsuevc = [[RaceSignUpEventsViewController alloc] initWithNibName:@"RaceSignUpEventsViewController" bundle:nil data:dataDict];
            [self.navigationController pushViewController:rsuevc animated:YES];
            [rsuevc release];
        }else if(indexPath.row == 1){ // Register someone else
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantSomeoneElse];
            SignUpViewController *suvc = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
            [suvc setSignUpMode: RSUSignUpSomeoneElse];
            [suvc setDelegate: self];
            [self presentViewController:suvc animated:YES completion:nil];
            [suvc release];
        }else if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            [[RSUModel sharedModel] logout];
            [tableView reloadData];
        }else{ // Register a secondary user
            [[RSUModel sharedModel] setRegistrantType: RSURegistrantSecondary];
            NSDictionary *secondaryUser = [[[[RSUModel sharedModel] currentUser] objectForKey:@"secondary_users"] objectAtIndex: indexPath.row - 2];
            [self didSignUpWithDictionary: secondaryUser];
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
            [suvc setSignUpMode: RSUSignUpNewUser];
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
        }else if(indexPath.row == [tableView numberOfRowsInSection: 0] - 1){
            [[cell textLabel] setText:@"Sign Out"];
        }else{
            NSDictionary *user = [[[[RSUModel sharedModel] currentUser] objectForKey:@"secondary_users"] objectAtIndex: indexPath.row - 2];
            [[cell textLabel] setText: [NSString stringWithFormat: @"Register %@ %@", [user objectForKey: @"first_name"], [user objectForKey: @"last_name"]]];
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
        return 3 + [[[[RSUModel sharedModel] currentUser] objectForKey:@"secondary_users"] count];
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
