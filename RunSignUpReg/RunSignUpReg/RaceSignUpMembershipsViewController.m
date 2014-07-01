//
//  RaceSignUpMembershipsViewController.m
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

#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpMembershipsTableViewCell.h"
#import "RaceSignUpQuestionsViewController.h"

@implementation RaceSignUpMembershipsViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        [dataDict retain];
        
        for(NSMutableDictionary *setting in [dataDict objectForKey: @"membership_settings"]){
            [setting setObject:@"NO" forKey:@"active"];
        }
        
        self.title = @"Memberships";
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] != [self tableView:tableView numberOfRowsInSection:0] - 1){
        RaceSignUpMembershipsTableViewCell *cell = [[RaceSignUpMembershipsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [[cell nameLabel] setText: [NSString stringWithFormat:@"%@ (%@)", [[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"membership_setting_name"], [[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"price_adjustment"]]];
        
        if([[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"membership_setting_addl_field"]){
            [cell setDelegate: self];
            NSString *fieldText = [[[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"membership_setting_addl_field"] objectForKey:@"field_text"];
            [[cell additionalFieldHint] setText: fieldText];
            if([[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"user_notice"]){
                [cell setOptionalNoticeText: [[[dataDict objectForKey:@"membership_settings"] objectAtIndex: indexPath.row] objectForKey:@"user_notice"]];
            }
        }
        
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
            [answerButton addTarget:self action:@selector(chooseMemberships:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != [[dataDict objectForKey: @"membership_settings"] count]){
        [tableView beginUpdates];
        if([[[[dataDict objectForKey: @"membership_settings"] objectAtIndex: indexPath.row] objectForKey: @"active"] boolValue]){
            [[[dataDict objectForKey: @"membership_settings"] objectAtIndex: indexPath.row] setObject:@"NO" forKey:@"active"];
            [(RaceSignUpMembershipsTableViewCell *)[tableView cellForRowAtIndexPath: indexPath] setActive: NO];
        }else{
            [[[dataDict objectForKey: @"membership_settings"] objectAtIndex: indexPath.row] setObject:@"YES" forKey:@"active"];
            [(RaceSignUpMembershipsTableViewCell *)[tableView cellForRowAtIndexPath: indexPath] setActive: YES];
        }
        [tableView endUpdates];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != [self tableView:tableView numberOfRowsInSection:0] - 1){
        if([[[[dataDict objectForKey: @"membership_settings"] objectAtIndex: indexPath.row] objectForKey: @"active"] boolValue]){
            NSString *userNotice = [[[dataDict objectForKey: @"membership_settings"] objectAtIndex: indexPath.row] objectForKey: @"user_notice"];
            if(userNotice){
                CGSize reqSize = [userNotice sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(312, INFINITY)];
                return reqSize.height + 104;
            }else{
                return 100;
            }
        }else{
            return 54;
        }
    }else
        return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dataDict objectForKey: @"membership_settings"] count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)chooseMemberships:(id)sender{
    NSMutableArray *memberships = [[NSMutableArray alloc] init];
    BOOL membershipSettingsValid = YES;
    for(int i = 0; i < [[dataDict objectForKey: @"membership_settings"] count]; i++){
        NSDictionary *setting = [[dataDict objectForKey: @"membership_settings"] objectAtIndex: i];
        if([setting objectForKey: @"membership_setting_addl_field"]){
            if([[setting objectForKey: @"active"] boolValue]){
                if([[[setting objectForKey: @"membership_setting_addl_field"] objectForKey: @"required"] boolValue]){
                    RaceSignUpMembershipsTableViewCell *cell = (RaceSignUpMembershipsTableViewCell *)[table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
                    if([[[cell additionalField] text] length] > 0){
                        int destInt;
                        if([[setting objectForKey: @"usatf_specific"] boolValue]){
                            if([[NSScanner scannerWithString: [[cell additionalField] text]] scanInt: &destInt]){
                                if(destInt < 0){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid USATF membership ID in the text field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }
                            }else{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid USATF membership ID in the text field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }
                        }
                        
                        NSMutableDictionary *membership = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[setting objectForKey:@"membership_setting_id"], @"membership_setting_id", @"T", @"is_member", [[cell additionalField] text], @"addl_field", nil];
                        [memberships addObject: membership];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more required additional fields is empty" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        
                        membershipSettingsValid = NO;
                    }
                }
            }
        }
    }
    
    if([memberships count] > 0)
        [dataDict setObject:memberships forKey:@"memberships"];
    
    if(membershipSettingsValid){
        RaceSignUpQuestionsViewController *rsuqvc = [[RaceSignUpQuestionsViewController alloc] initWithNibName:@"RaceSignUpQuestionsViewController" bundle:nil data:dataDict];
        [self.navigationController pushViewController:rsuqvc animated:YES];
        [rsuqvc release];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIBarButtonItem *hide = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    [self.navigationItem setRightBarButtonItem: hide];
    
    int totalHeight = 22; //header height
    for(int i = 0; i < [self tableView:table numberOfRowsInSection:0]; i++){
        totalHeight += [self tableView:table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView beginAnimations:@"TableSize" context:nil];
    [UIView setAnimationDuration: 0.3f];
    [table setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216)];
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.4f), dispatch_get_main_queue(), ^{
        [self textField:textField shouldChangeCharactersInRange:NSRangeFromString(@"0-0") replacementString:nil];
    });
    
    currentTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([[[textField superview] superview] isKindOfClass: [RaceSignUpQuestionsTableViewCell class]]){
        // iOS < 6.0
        NSIndexPath *index = [table indexPathForCell: (UITableViewCell *)[[textField superview] superview]];
        [table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if([[[[textField superview] superview] superview] isKindOfClass: [RaceSignUpQuestionsTableViewCell class]]){
        // iOS > 7.0
        NSIndexPath *index = [table indexPathForCell: (UITableViewCell *)[[[textField superview] superview] superview]];
        [table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.navigationItem setRightBarButtonItem: nil];
    
    int totalHeight = 22; //header height
    for(int i = 0; i < [self tableView:table numberOfRowsInSection:0]; i++){
        totalHeight += [self tableView:table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView beginAnimations:@"TableSize" context:nil];
    [UIView setAnimationDuration: 0.3f];
    [table setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //[table setContentSize: CGSizeMake(320, totalHeight)];
    [UIView commitAnimations];
}

- (void)hideKeyboard{
    [currentTextField resignFirstResponder];
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
