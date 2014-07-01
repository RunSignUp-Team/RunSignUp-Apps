//
//  RaceSignUpQuestionsTableViewCell.m
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

#import "RaceSignUpQuestionsTableViewCell.h"
#import "RaceSignUpQuestionsViewController.h"

@implementation RaceSignUpQuestionsTableViewCell
@synthesize questionLabel;
@synthesize selectedArray;
@synthesize questionID;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.questionLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 8, 312, 20)];
        [questionLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [questionLabel setLineBreakMode: NSLineBreakByWordWrapping];
        [questionLabel setNumberOfLines: 0];
        
        [self.contentView addSubview: questionLabel];
    }
    return self;
}

- (void)valueDidChange{
    [delegate didChangeResponse:[self response] forQuestionID:questionID];
}

- (id)response{
    if(type == RSUQuestionTypeFreeform)
        return [freeformField text];
    else if(type == RSUQuestionTypeBoolean){
        if([booleanControl selectedSegmentIndex] == 0)
            return @"T";
        else
            return @"F";
    }else if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio){
        int selection = -1;
        for(int i = 0; i < [selectedArray count]; i++){
            if([[selectedArray objectAtIndex: i] boolValue])
                selection = i;
        }
        
        if(selection != -1)
            return [NSString stringWithFormat: @"%i", [[[responses objectAtIndex: selection] objectForKey: @"response_id"] intValue]];
        else
            return @"-1";
    }else if(type == RSUQuestionTypeCheck){
        NSMutableArray *responseIDs = [[NSMutableArray alloc] init];
        for(int i = 0; i < [selectedArray count]; i++){
            if([[selectedArray objectAtIndex: i] boolValue]){
                int responseID = [[[responses objectAtIndex: i] objectForKey: @"response_id"] intValue];
                [responseIDs addObject: [NSString stringWithFormat: @"%i", responseID]];
            }
        }
        return responseIDs;
    }else{
        int hours = [timePicker selectedRowInComponent: 0];
        int min = [timePicker selectedRowInComponent: 1];
        int sec = [timePicker selectedRowInComponent: 2];
        
        return [NSString stringWithFormat: @"%i:%02i:%02i", hours, min, sec];
    }
}

- (void)reset{
    for(UIView *view in [self.contentView subviews]){
        if(view != questionLabel)
            [view removeFromSuperview];
    }
}

- (void)setCurrentResponse:(id)resp{
    if(type == RSUQuestionTypeFreeform){
        [freeformField setText: (NSString *)resp];
    }else if(type == RSUQuestionTypeBoolean){
        [booleanControl setSelectedSegmentIndex: ![resp boolValue]];
    }else if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio){
        for(int i = 0; i < [responses count]; i++){
            if([[[responses objectAtIndex: i] objectForKey: @"response_id"] isEqualToString: (NSString *)resp]){
                [selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool: YES]];
                [[[selectionTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]] accessoryView] setHidden: NO];
            }
        }
    }else if(type == RSUQuestionTypeCheck){
        for(int i = 0; i < [responses count]; i++){
            for(NSString *respID in (NSArray *)resp){
                if([[[responses objectAtIndex: i] objectForKey: @"response_id"] isEqualToString: respID]){
                    [selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool: YES]];
                    [[[selectionTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]] accessoryView] setHidden: NO];
                }
            }
        }
    }else if(type == RSUQuestionTypeTime){
        NSLog(@"set for time %@", resp);
    }
}

- (void)setType:(RSUQuestionType)t{
    type = t;
    
    for(UIView *subview in self.contentView.subviews){
        if(subview != questionLabel){
            [subview release];
        }
    }
    
    if(t == RSUQuestionTypeFreeform){
        freeformField = [[UITextField alloc] initWithFrame: CGRectMake(8, 14 + [questionLabel frame].size.height, 304, 30)];
        [freeformField setBorderStyle: UITextBorderStyleRoundedRect];
        [freeformField setReturnKeyType: UIReturnKeyNext];
        [freeformField setDelegate: delegate];
        [freeformField addTarget:self action:@selector(valueDidChange) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview: freeformField];
    }else if(t == RSUQuestionTypeBoolean){
        booleanControl = [[UISegmentedControl alloc] initWithItems:@[@"Yes", @"No"]];
        [booleanControl setFrame: CGRectMake(8, 14 + [questionLabel frame].size.height, 304, 30)];
        [booleanControl addTarget:self action:@selector(valueDidChange) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview: booleanControl];
    }else if(t == RSUQuestionTypeSelection || t == RSUQuestionTypeRadio || t == RSUQuestionTypeCheck){
        NSLog(@"Table frame: %@", NSStringFromCGRect(CGRectMake(0, 14 + [questionLabel frame].size.height, 320, 30)));
        selectionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 14 + [questionLabel frame].size.height, 320, 30) style:UITableViewStylePlain];
        [selectionTable setDelegate: self];
        [selectionTable setDataSource: self];
        [selectionTable setScrollEnabled: NO];
        [self.contentView addSubview: selectionTable];
    }else if(t == RSUQuestionTypeTime){
        timePicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 14 + [questionLabel frame].size.height, 320, 216)];
        [timePicker setDelegate: self];
        [timePicker setDataSource: self];
        [self.contentView addSubview: timePicker];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 98, 320, 20)];
        [headerLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [headerLabel setText: @"  Hrs:             Min:              Sec:"];
        [timePicker addSubview: headerLabel];
    }
}

- (RSUQuestionType)type{
    return type;
}

- (void)setResponses:(NSArray *)r{
    responses = r;
    self.selectedArray = [[NSMutableArray alloc] init];

    for(int x = 0; x < [responses count]; x++){
        [selectedArray addObject: [NSNumber numberWithBool:NO]];
    }
    
    if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio || type == RSUQuestionTypeCheck){
        [selectionTable setFrame: CGRectMake(0, 14 + [questionLabel frame].size.height, 320, 30 * [responses count])];
    }
    
    [selectionTable reloadData];
    
    /*if(type == RSUQuestionTypeRadio){
        [selectedArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool: YES]];
        [[[selectionTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]] accessoryView] setHidden: NO];
    }*/
}

- (NSArray *)responses{
    return responses;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio){
        for(int i = 0; i < [selectedArray count]; i++){
            [selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool: NO]];
            [[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] accessoryView] setHidden: YES];
        }
        
        [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool: YES]];
        [[[tableView cellForRowAtIndexPath: indexPath] accessoryView] setHidden: NO];
        
        [self valueDidChange];
    }else{
        BOOL oppositeBool = ![[selectedArray objectAtIndex: indexPath.row] boolValue];
        [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool: oppositeBool]];
        if(oppositeBool)
            [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
        else
            [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryNone];
        
        [self valueDidChange];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText: [[responses objectAtIndex: indexPath.row] objectForKey: @"response"]];
    if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio){
        UIImageView *radioImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QuestionsRadio.png"]];
        [cell setAccessoryView: radioImage];
        [cell.accessoryView setHidden: YES];
    }else{
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    }
    
    UIImageView *checkImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"QuestionsCheckbox.png"]];
    [checkImage setFrame: CGRectMake(288, 4, 20, 20)];
    [cell.contentView addSubview: checkImage];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [responses count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat: @"%i", row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 60;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self valueDidChange];
}

- (int)requiredHeight{
    if(type == RSUQuestionTypeFreeform)
        return 52 + [questionLabel frame].size.height;
    else if(type == RSUQuestionTypeBoolean)
        return 52 + [questionLabel frame].size.height;
    else if(type == RSUQuestionTypeSelection || type == RSUQuestionTypeRadio || type == RSUQuestionTypeCheck)
        return 13 + 30 * [responses count] + [questionLabel frame].size.height;
    else
        return 240;
}

- (void)setFreeformKeyboardType:(UIKeyboardType)ktype{
    [freeformField setKeyboardType: ktype];
}

- (void)setFreeformPlaceholderText:(NSString *)text{
    [freeformField setPlaceholder: text];
}

- (void)setQuestionLabelText:(NSString *)text{
    CGSize requiredSize = [text sizeWithFont:[questionLabel font] constrainedToSize:CGSizeMake(312, 300) lineBreakMode:NSLineBreakByWordWrapping];
    [questionLabel setFrame: CGRectMake(4, 8, requiredSize.width, requiredSize.height)];
    [questionLabel setText: text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
