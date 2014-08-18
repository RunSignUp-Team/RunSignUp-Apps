//
//  RaceSignUpQuestionsViewController.m
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

#import "RaceSignUpQuestionsViewController.h"
#import "RaceSignUpQuestionsTableViewCell.h"
#import "RaceSignUpMembershipsViewController.h"
#import "RaceSignUpPaymentViewController.h"
#import "RSUModel.h"

@implementation RaceSignUpQuestionsViewController
@synthesize table;
@synthesize responses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataDict = data;
        self.responses = [[NSMutableArray alloc] init];
        
        NSMutableSet *eventIDs = [[NSMutableSet alloc] init];
        for(NSDictionary *event in [dataDict objectForKey: @"events"])
            [eventIDs addObject: [event objectForKey: @"event_id"]];

        for(int i = 0; i < [[dataDict objectForKey:@"questions"] count]; i++){
            NSDictionary *question = [[dataDict objectForKey: @"questions"] objectAtIndex: i];
            
            if([self shouldAskQuestion: question]){
                NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                [responseDict setObject:[question objectForKey:@"question_id"] forKey:@"question_id"];
                [responseDict setObject:[question objectForKey:@"question_type_code"] forKey:@"question_type_code"];
                [responseDict setObject:[self defaultResponseForQuestion:question] forKey:@"response"];
                [responseDict setObject:[question objectForKey:@"individual"] forKey:@"individual"];
                [responseDict setObject:[question objectForKey:@"question_text"] forKey:@"text"];
                if([question objectForKey:@"question_validation_type"])
                    [responseDict setObject:[question objectForKey:@"question_validation_type"] forKey:@"question_validation_type"];
                [responses addObject: responseDict];
            }
        }
        
        NSLog(@"Responses: %@", responses);
        
        NSLog(@"Questions data: %@", data);
        
        self.title = @"Questions";
    }
    return self;
}

- (NSDictionary *)questionForQuestionID:(NSString *)questionID{
    for(NSDictionary *question in [dataDict objectForKey: @"questions"]){
        if([[question objectForKey: @"question_id"] isEqualToString: questionID])
            return question;
    }
    
    return nil;
}

- (id)currentResponseForQuestion:(NSDictionary *)question{
    for(NSDictionary *response in responses){
        if([[response objectForKey:@"question_id"] isEqualToString: [question objectForKey: @"question_id"]])
            return [response objectForKey: @"response"];
    }
    return nil;
}

- (id)defaultResponseForQuestion:(NSDictionary *)question{
    if([[question objectForKey:@"question_type_code"] isEqualToString:@"F"])
        return @"";
    else if([[question objectForKey:@"question_type_code"] isEqualToString:@"B"])
        return @"F";
    else if([[question objectForKey:@"question_type_code"] isEqualToString:@"S"])
        return [NSArray array];
    else if([[question objectForKey:@"question_type_code"] isEqualToString:@"R"]){
        NSString *defaultID = [[[question objectForKey: @"responses"] firstObject] objectForKey:@"response_id"];
        return defaultID;
    }else if([[question objectForKey:@"question_type_code"] isEqualToString:@"C"])
        return [NSArray array];
    else
        return @"0:00:00";
}

- (BOOL)shouldAskQuestion:(NSDictionary *)question{
    BOOL skipped = NO;
    BOOL parentMatch = YES;
    
    NSMutableSet *eventIDs = [[NSMutableSet alloc] init];
    for(NSDictionary *event in [dataDict objectForKey: @"events"])
        [eventIDs addObject: [event objectForKey: @"event_id"]];
    
    if([question objectForKey: @"skip_for_event_ids"]){
        if([eventIDs isSubsetOfSet: [NSSet setWithArray: [question objectForKey: @"skip_for_event_ids"]]]){
            skipped = YES;
        }
    }
    
    if([question objectForKey: @"parent_question_id"]){
        NSDictionary *parentQuestion = nil;
        for(NSDictionary *question2 in [dataDict objectForKey: @"questions"]){
            if([[question2 objectForKey: @"question_id"] isEqualToString: [question objectForKey:@"parent_question_id"]]){
                if([question2 objectForKey: @"skip_for_event_ids"]){
                    if(![eventIDs isSubsetOfSet: [NSSet setWithArray: [question2 objectForKey: @"skip_for_event_ids"]]]){
                        parentQuestion = question2;
                        break;
                    }
                }else{
                    parentQuestion = question2;
                    break;
                }
            }
        }
        
        NSDictionary *parentResponse = nil;
        for(NSDictionary *response in responses)
            if([[response objectForKey: @"question_id"] isEqualToString: [parentQuestion objectForKey:@"question_id"]])
                parentResponse = response;
        
        if(parentQuestion && parentResponse){
            if([question objectForKey: @"parent_visible_bool_response"] && [[parentQuestion objectForKey:@"question_type_code"] isEqualToString:@"B"]){
                if([[parentResponse objectForKey:@"response"] isEqualToString:@"none"] || [[question objectForKey: @"parent_visible_bool_response"] boolValue] != [[parentResponse objectForKey: @"response"] boolValue]){
                    parentMatch = NO;
                }
            }
        }
    }
    return (!skipped && parentMatch);
}

- (void)didChangeResponse:(id)response forQuestionID:(NSString *)questionID{
    for(int i = 0; i < [responses count]; i++){
        NSDictionary *responseDict = [responses objectAtIndex: i];
        if([[responseDict objectForKey: @"question_id"] isEqualToString: questionID]){
            NSMutableDictionary *newResponseDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:questionID, @"question_id", response, @"response", [responseDict objectForKey:@"text"], @"text", [responseDict objectForKey:@"individual"], @"individual", nil];
            if([responseDict objectForKey:@"question_validation_type"])
                [newResponseDict setObject:[responseDict objectForKey:@"question_validation_type"] forKey:@"question_validation_type"];
            [responses replaceObjectAtIndex:i withObject:newResponseDict];
            
            BOOL hasChildQuestion = NO;
            BOOL inserting = YES;
            BOOL deletedResponse = NO;
            int childQuestionIndex = 0;
            for(NSDictionary *question in [dataDict objectForKey: @"questions"]){
                if([question objectForKey:@"parent_question_id"]){
                    if([[question objectForKey: @"parent_question_id"] isEqualToString: questionID]){
                        hasChildQuestion = YES;
                        
                        inserting = [self shouldAskQuestion: question];
                        
                        if(inserting){
                            NSMutableDictionary *newResponseDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[question objectForKey:@"question_id"], @"question_id", [self defaultResponseForQuestion: question], @"response", [question objectForKey:@"question_text"], @"text", [question objectForKey:@"individual"], @"individual", nil];
                            [responses addObject: newResponseDict];
                        }else{
                            NSDictionary *responseToDelete = nil;
                            for(NSDictionary *response in responses){
                                if([[response objectForKey:@"question_id"] isEqualToString: [question objectForKey:@"question_id"]]){
                                    responseToDelete = response;
                                }
                            }
                            
                            if(responseToDelete != nil){
                                [responses removeObject: responseToDelete];
                                deletedResponse = YES;
                            }
                        }
                        break;
                    }
                }
                
                if([self shouldAskQuestion: question]){
                    childQuestionIndex++;
                }
            }
            
            if(hasChildQuestion){
                if(inserting){
                    NSLog(@"Inserting child question at index %i", childQuestionIndex);
                    [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:childQuestionIndex inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                    [table reloadSections:[NSIndexSet indexSetWithIndex: 1] withRowAnimation:UITableViewRowAnimationTop];
               
                }else if(deletedResponse){
                    NSLog(@"Remove child question at index %i", childQuestionIndex);
                    [table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:childQuestionIndex inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                    [table reloadSections:[NSIndexSet indexSetWithIndex: 1] withRowAnimation:UITableViewRowAnimationTop];
                    
                }
            }
        }
    }
    
    NSLog(@"Responses: %@", responses);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *QuestionCellIdentifier = @"QuestionsCellIdentifier";
    static NSString *CellIdentifier = @"CellIdentifier";
    
    if([indexPath section] == 0){
        RaceSignUpQuestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: QuestionCellIdentifier];
        if(cell == nil)
            cell = [[RaceSignUpQuestionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuestionCellIdentifier];
        
        [cell reset];
        
        NSDictionary *actualQuestion = nil;
        int index = (int)indexPath.row;
        NSMutableSet *eventIDs = [[NSMutableSet alloc] init];
        for(NSDictionary *event in [dataDict objectForKey: @"events"])
            [eventIDs addObject: [event objectForKey: @"event_id"]];
        
        for(NSDictionary *question in [dataDict objectForKey: @"questions"]){
            if([self shouldAskQuestion: question])
                index--;
            
            if(index < 0){
                actualQuestion = question;
                break;
            }
        }
        
        if(actualQuestion != nil){
            [cell setQuestionLabelText: [actualQuestion objectForKey: @"question_text"]];
            [cell setDelegate: self];
            
            NSString *typeCode = [actualQuestion objectForKey: @"question_type_code"];
            if([typeCode isEqualToString:@"F"]){
                [cell setType: RSUQuestionTypeFreeform];
                NSString *validationType = [actualQuestion objectForKey: @"question_validation_type"];
                if(validationType){
                    NSString *defaultText = nil;
                    if([validationType isEqualToString:@"uint"]){
                        defaultText = @"Positive whole number";
                        [cell setFreeformKeyboardType: UIKeyboardTypeNumberPad];
                    }else if([validationType isEqualToString:@"int"]){
                        defaultText = @"Whole number";
                        [cell setFreeformKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
                    }else if([validationType isEqualToString:@"float"]){
                        defaultText = @"Decimal number";
                        [cell setFreeformKeyboardType: UIKeyboardTypeDecimalPad];
                    }else if([validationType isEqualToString:@"email"]){
                        defaultText = @"E-mail address";
                        [cell setFreeformKeyboardType: UIKeyboardTypeEmailAddress];
                    }else if([validationType isEqualToString:@"phone"]){
                        defaultText = @"Phone number";
                        [cell setFreeformKeyboardType: UIKeyboardTypePhonePad];
                    }else if([validationType isEqualToString:@"date"]){
                        defaultText = @"Date (mm/dd/yyyy)";
                        [cell setFreeformKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
                    }
                    if(defaultText != nil)
                        [cell setFreeformPlaceholderText: defaultText];
                }
            }else if([typeCode isEqualToString:@"B"]){
                [cell setType: RSUQuestionTypeBoolean];
            }else if([typeCode isEqualToString:@"S"]){
                [cell setType: RSUQuestionTypeSelection];
                [cell setResponses: [actualQuestion objectForKey: @"responses"]];
            }else if([typeCode isEqualToString:@"R"]){
                [cell setType: RSUQuestionTypeRadio];
                [cell setResponses: [actualQuestion objectForKey: @"responses"]];
            }else if([typeCode isEqualToString:@"C"]){
                [cell setType: RSUQuestionTypeCheck];
                [cell setResponses: [actualQuestion objectForKey: @"responses"]];
            }else{
                [cell setType: RSUQuestionTypeTime];
            }
            
            [cell setCurrentResponse: [self currentResponseForQuestion: actualQuestion]];
            [cell setQuestionID: [actualQuestion objectForKey: @"question_id"]];
        }
        return cell;
    }else{
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
            //[answerButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
            [answerButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
            [[answerButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:18]];
            
            [[cell contentView] addSubview: answerButton];
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        int numQuestions = 0;
        NSMutableSet *eventIDs = [[NSMutableSet alloc] init];
        for(NSDictionary *event in [dataDict objectForKey: @"events"])
            [eventIDs addObject: [event objectForKey: @"event_id"]];
        
        for(NSDictionary *question in [dataDict objectForKey: @"questions"]){
            if([self shouldAskQuestion: question]){
                numQuestions++;
            }
        }
                
        return numQuestions;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        if([[RSUModel sharedModel] registrantType] != RSURegistrantMe)
            return [NSString stringWithFormat: @"Questions for %@ %@", [[dataDict objectForKey: @"registrant"] objectForKey: @"first_name"], [[dataDict objectForKey: @"registrant"] objectForKey: @"last_name"]];
        else
            return [NSString stringWithFormat: @"Questions for %@ %@", [[[RSUModel sharedModel] currentUser] objectForKey: @"first_name"], [[[RSUModel sharedModel] currentUser] objectForKey: @"last_name"]];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section] == 0){
        NSDictionary *actualQuestion = nil;
        int index = (int)indexPath.row;
        NSMutableSet *eventIDs = [[NSMutableSet alloc] init];
        for(NSDictionary *event in [dataDict objectForKey: @"events"])
            [eventIDs addObject: [event objectForKey: @"event_id"]];
        
        for(NSDictionary *question in [dataDict objectForKey: @"questions"]){
            if([self shouldAskQuestion: question])
                index--;
            
            if(index < 0){
                actualQuestion = question;
                break;
            }
        }
        
        NSString *typeCode = [actualQuestion objectForKey:@"question_type_code"];
        
        CGSize reqSize = [[actualQuestion objectForKey:@"question_text"] sizeWithFont:[UIFont fontWithName:@"OpenSans" size:18] constrainedToSize: CGSizeMake(312, 300) lineBreakMode: NSLineBreakByWordWrapping];
        
        if([typeCode isEqualToString:@"F"])
            return 62 + reqSize.height;
        else if([typeCode isEqualToString:@"B"])
            return 62 + reqSize.height;
        else if([typeCode isEqualToString:@"S"] || [typeCode isEqualToString:@"R"] || [typeCode isEqualToString:@"C"])
            return 24 + reqSize.height + [[actualQuestion objectForKey: @"responses"] count] * 30;
        else
            return 220 + reqSize.height;
    }else
        return 54;
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

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)answerQuestions:(id)sender{
    NSMutableArray *indivQuestionResponses = [[NSMutableArray alloc] init];
    NSMutableArray *allQuestionResponses = [[NSMutableArray alloc] init];
    for(int i = 0; i < [responses count]; i++){
        NSDictionary *response = [responses objectAtIndex: i];
        NSDictionary *responseDict = [[NSDictionary alloc] initWithObjectsAndKeys:[response objectForKey:@"text"], @"text", [response objectForKey:@"question_id"], @"question_id", [response objectForKey:@"response"], @"response", nil];
        
        NSDictionary *question = [self questionForQuestionID: [response objectForKey: @"question_id"]];
        
        if([[response objectForKey:@"response"] isKindOfClass: [NSString class]]){
            if([(NSString *)[response objectForKey:@"response"] length] <= 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill the freeform response field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                return;
            }
            
            if([response objectForKey:@"question_validation_type"]){
                if([[response objectForKey:@"question_validation_type"] isEqualToString: @"uint"]){
                    BOOL valid = YES;
                    int destInt;
                    NSScanner *scanner = [NSScanner scannerWithString: [response objectForKey: @"response"]];
                    if(![scanner scanInt: &destInt] || ![scanner isAtEnd])
                        valid = NO;
                    else{
                        if(destInt < 0){
                            valid = NO;
                        }
                    }
                    
                    if(!valid){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a positive whole number in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"int"]){
                    NSScanner *scanner = [NSScanner scannerWithString: [response objectForKey: @"response"]];
                    if(![scanner scanInt: nil] || ![scanner isAtEnd]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a whole number in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"float"]){
                    NSScanner *scanner = [NSScanner scannerWithString: [response objectForKey: @"response"]];
                    if(![scanner scanFloat: nil] || ![scanner isAtEnd]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a decimal number in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"email"]){
                    if([[response objectForKey: @"response"] rangeOfString:@"@"].location == NSNotFound){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                        
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"phone"]){
                    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:nil];
                    if([detector numberOfMatchesInString:[response objectForKey:@"response"] options:0 range:NSMakeRange(0, [(NSString *)[response objectForKey:@"response"] length])] != 1){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid phone number in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"date"]){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"MM/dd/yyyy"];
                    
                    if([dateFormatter dateFromString: [response objectForKey: @"response"]] == nil){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid date in the freeform field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                }else if([[response objectForKey:@"question_validation_type"] isEqualToString: @"char_limit"]){
                    NSDictionary *question = [self questionForQuestionID: [response objectForKey: @"question_id"]];
                    if([question objectForKey: @"max_response_length"] && [question objectForKey: @"min_response_length"]){
                        int min = [[question objectForKey: @"min_response_length"] intValue];
                        int max = [[question objectForKey: @"max_response_length"] intValue];
                        if([[response objectForKey: @"response"] length] > max){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter a response in the freeform field that is less than %i characters", max] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                            return;
                        }else if([[response objectForKey: @"response"] length] < min){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter a response in the freeform field that is more than %i characters", min] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                            return;
                        }
                    }
                }
            }
        }else if([[response objectForKey:@"question_type_code"] isEqualToString:@"B"]){
            if([[response objectForKey: @"response"] isEqualToString:@"none"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please answer the question \"%@\" by selecting yes or no.", [question objectForKey: @"question_text"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }else if([[response objectForKey: @"response"] isKindOfClass: [NSArray class]] || [[response objectForKey: @"response"] isKindOfClass: [NSMutableArray class]]){
            if([[response objectForKey: @"response"] count] < 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please answer the question \"%@\".", [question objectForKey: @"question_text"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }
        
        if([[response objectForKey:@"individual"] boolValue])
            [indivQuestionResponses addObject: responseDict];
        else
            [allQuestionResponses addObject: responseDict];
    }
    
    if([indivQuestionResponses count] > 0){
        [dataDict setObject:indivQuestionResponses forKey:@"individual_question_responses"];
    }
    if([allQuestionResponses count] > 0)
        [dataDict setObject:allQuestionResponses forKey:@"question_responses"];
    
    NSLog(@"DataDict: %@", dataDict);
    
    [self hideKeyboard];
    
    RaceSignUpPaymentViewController *rsupvc = [[RaceSignUpPaymentViewController alloc] initWithNibName:@"RaceSignUpPaymentViewController" bundle:nil data:dataDict];
    [self.navigationController pushViewController:rsupvc animated:YES];
    [rsupvc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
