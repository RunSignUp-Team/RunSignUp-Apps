//
//  RaceSignUpQuestionsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import "RaceSignUpQuestionsViewController.h"
#import "RaceSignUpQuestionsTableViewCell.h"
#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpPaymentViewController.h"

@implementation RaceSignUpQuestionsViewController
@synthesize table;
@synthesize responses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        self.responses = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < [[dataDict objectForKey:@"questions"] count]; i++){
            NSDictionary *question = [[dataDict objectForKey: @"questions"] objectAtIndex: i];
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setObject:[question objectForKey:@"question_id"] forKey:@"question_id"];
            
            if([[question objectForKey:@"question_type_code"] isEqualToString:@"F"])
                [responseDict setObject:@"" forKey:@"response"];
            else if([[question objectForKey:@"question_type_code"] isEqualToString:@"B"])
                [responseDict setObject:[NSNumber numberWithBool:YES] forKey:@"response"];
            else if([[question objectForKey:@"question_type_code"] isEqualToString:@"S"])
                [responseDict setObject:nil forKey:@"response"];
            else if([[question objectForKey:@"question_type_code"] isEqualToString:@"R"]){
                NSString *defaultID = [[[question objectForKey: @"responses"] firstObject] objectForKey:@"response_id"];
                [responseDict setObject:defaultID forKey:@"response"];
            }else if([[question objectForKey:@"question_type_code"] isEqualToString:@"C"])
                [responseDict setObject:[[NSArray alloc] init] forKey:@"response"];
            else
                [responseDict setObject:@"0:0:0" forKey:@"response"];
            [responses addObject: responseDict];
        }
        
        NSLog(@"Responses: %@", responses);
        
        self.title = @"Questions";
    }
    return self;
}

- (void)didChangeResponse:(id)response forQuestionID:(NSString *)questionID{
    for(int i = 0; i < [responses count]; i++){
        NSDictionary *responseDict = [responses objectAtIndex: i];
        if([[responseDict objectForKey: @"question_id"] isEqualToString: questionID]){
            NSDictionary *newResponseDict = [[NSDictionary alloc] initWithObjectsAndKeys:questionID, @"question_id", response, @"response", nil];
            [responses replaceObjectAtIndex:i withObject:newResponseDict];
            break;
        }
    }
    
    NSLog(@"Responses: %@", responses);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] != [[dataDict objectForKey:@"questions"] count]){
        RaceSignUpQuestionsTableViewCell *cell = [[RaceSignUpQuestionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setQuestionLabelText: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"question_text"]];
        [cell setDelegate: self];
        
        NSString *typeCode = [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"question_type_code"];
        if([typeCode isEqualToString:@"F"]){
            [cell setType: RSUQuestionTypeFreeform];
        }else if([typeCode isEqualToString:@"B"]){
            [cell setType: RSUQuestionTypeBoolean];
        }else if([typeCode isEqualToString:@"S"]){
            [cell setType: RSUQuestionTypeSelection];
            [cell setResponses: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"responses"]];
        }else if([typeCode isEqualToString:@"R"]){
            [cell setType: RSUQuestionTypeRadio];
            [cell setResponses: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"responses"]];
        }else if([typeCode isEqualToString:@"C"]){
            [cell setType: RSUQuestionTypeCheck];
            [cell setResponses: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"responses"]];
        }else{
            [cell setType: RSUQuestionTypeTime];
        }
        
        [cell setQuestionID: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"question_id"]];
        
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
            [answerButton addTarget:self action:@selector(answerQuestions:) forControlEvents:UIControlEventTouchUpInside];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dataDict objectForKey: @"questions"] count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat: @"Questions for %@ %@", [[dataDict objectForKey: @"registrant"] objectForKey: @"first_name"], [[dataDict objectForKey: @"registrant"] objectForKey: @"last_name"]];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] != [[dataDict objectForKey: @"questions"] count])
        return [(RaceSignUpQuestionsTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath] requiredHeight];
    else
        return 54;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIBarButtonItem *hide = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    [self.navigationItem setRightBarButtonItem: hide];
    
    int totalHeight = 22; //header height
    for(int i = 0; i < [self tableView:table numberOfRowsInSection:0]; i++){
        totalHeight += [self tableView:table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [table setContentSize: CGSizeMake(320, totalHeight + 216)];
    
    currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.navigationItem setRightBarButtonItem: nil];
    
    int totalHeight = 22; //header height
    for(int i = 0; i < [self tableView:table numberOfRowsInSection:0]; i++){
        totalHeight += [self tableView:table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView beginAnimations:@"TableContentSize" context:nil];
    [UIView setAnimationDuration: 0.3f];
    [table setContentSize: CGSizeMake(320, totalHeight)];
    [UIView commitAnimations];
}

- (void)hideKeyboard{
    [currentTextField resignFirstResponder];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)answerQuestions:(id)sender{
    NSMutableArray *questionResponses = [[NSMutableArray alloc] init];
    for(int i = 0; i < [[dataDict objectForKey: @"questions"] count]; i++){
        RaceSignUpQuestionsTableViewCell *cell = (RaceSignUpQuestionsTableViewCell *)[self tableView:table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        id questionID = [[[dataDict objectForKey: @"questions"] objectAtIndex: i] objectForKey:@"question_id"];
        NSString *questionText = [[[dataDict objectForKey: @"questions"] objectAtIndex: i] objectForKey:@"question_text"];
        
        NSDictionary *responseDict = [[NSDictionary alloc] initWithObjectsAndKeys:questionText, @"text", questionID, @"question_id", [cell response], @"response", nil];
        [questionResponses addObject: responseDict];
    }
    
    NSLog(@"Responses: %@", questionResponses);
    
    if([dataDict objectForKey:@"membership_settings"] && [[dataDict objectForKey:@"membership_settings"] count] > 0){
        RaceSignUpMembershipsViewController *rsumvc = [[RaceSignUpMembershipsViewController alloc] initWithNibName:@"RaceSignUpMembershipsViewController" bundle:nil data:dataDict];
        [self.navigationController pushViewController:rsumvc animated:YES];
    }else{
        RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:dataDict];
        [self.navigationController pushViewController:rsupvc animated:YES];
        [rsupvc release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
