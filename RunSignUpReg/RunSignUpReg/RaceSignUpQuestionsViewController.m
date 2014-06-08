//
//  RaceSignUpQuestionsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import "RaceSignUpQuestionsViewController.h"
#import "RaceSignUpQuestionsTableViewCell.h"

@implementation RaceSignUpQuestionsViewController
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        // Custom initialization
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] != [[dataDict objectForKey:@"questions"] count]){
        static NSString *QuestionsCellIdentifier = @"QuestionsCellIdentifier";
        RaceSignUpQuestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionsCellIdentifier];
        if(cell == nil){
            cell = [[RaceSignUpQuestionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuestionsCellIdentifier];
        }
        [[cell questionLabel] setText: [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"question_text"]];
        
        NSString *typeCode = [[[dataDict objectForKey: @"questions"] objectAtIndex: [indexPath row]] objectForKey: @"question_type_code"];
        if([typeCode isEqualToString:@"F"]){
            [cell setType: RSUQuestionTypeFreeform];
        }else if([typeCode isEqualToString:@"B"]){
            [cell setType: RSUQuestionTypeBoolean];
        }else if([typeCode isEqualToString:@"S"]){
            [cell setType: RSUQuestionTypeSelection];
        }else if([typeCode isEqualToString:@"R"]){
            [cell setType: RSUQuestionTypeRadio];
        }else if([typeCode isEqualToString:@"C"]){
            [cell setType: RSUQuestionTypeRadio];
        }else{
            [cell setType: RSUQuestionTypeTime];
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
            [answerButton addTarget:self action:@selector(answerQuestions:) forControlEvents:UIControlEventTouchUpInside];
            [answerButton setFrame: CGRectMake(4, 4, 312, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 8)];
            [answerButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
            [answerButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
            [answerButton setTitle:@"Answer Questions" forState:UIControlStateNormal];
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
        return 100;
    else
        return 54;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)answerQuestions:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
