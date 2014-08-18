//
//  RaceResultsEventDetailsViewController.m
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

#import "RaceResultsEventDetailsViewController.h"

@implementation RaceResultsEventDetailsViewController
@synthesize scrollView;
@synthesize nameLabel;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        dataDict = data;
        
        self.title = @"Details";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSArray *keys = @[@"place", @"bib", @"gender", @"state", @"country_code", @"pace", @"clock_time", @"age", @"age_percentage"];
    NSArray *englishNames = @[@"Place", @"Bib", @"Gender", @"State", @"Country", @"Pace", @"Time", @"Age", @"Age %"];
    
    float rowHeight = 28;
    float nameHeight = [nameLabel frame].size.height;

    if([dataDict objectForKey:@"first_name"] && [dataDict objectForKey:@"last_name"]){
        [nameLabel setFont: [UIFont fontWithName:@"Sanchez-Regular" size:20]];
        [nameLabel setText: [NSString stringWithFormat: @"%@ %@", [dataDict objectForKey:@"first_name"], [dataDict objectForKey:@"last_name"]]];
    }
    
    UIImage *darkBlueButtonImage = [UIImage imageNamed:@"DarkBlueButton.png"];
    UIImage *stretchedDarkBlueButton = [darkBlueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *darkBlueButtonTapImage = [UIImage imageNamed:@"DarkBlueButtonTap.png"];
    UIImage *stretchedDarkBlueButtonTap = [darkBlueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [backButton setBackgroundImage:stretchedDarkBlueButton forState:UIControlStateNormal];
    [backButton setBackgroundImage:stretchedDarkBlueButtonTap forState:UIControlStateHighlighted];
    [[backButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:24]];

    
    /*UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(20, rowHeight, [self.view bounds].size.width - 40, 1)];
    [divider setBackgroundColor: [UIColor colorWithRed:64/255.0f green: 114/255.0f blue:148/255.0f alpha:1.0f]];
    [scrollView addSubview: divider];*/
    
    int labelCount = 0;
    for(int i = 0; i < [keys count]; i++){
        /*if([[keys objectAtIndex: i] isEqualToString: @"name"]){
            if([dataDict objectForKey:@"first_name"] && [dataDict objectForKey:@"last_name"]){
                UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 28 + labelCount * 24, 114, 20)];
                [nameLabel setTextColor: [UIColor colorWithRed:0.0f green: 148/255.0f blue:204/255.0f alpha:1.0f]];
                [nameLabel setText: @"Name:"];
                [nameLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
                [scrollView addSubview: nameLabel];
                
                NSString *name = [NSString stringWithFormat: @"%@ %@", [dataDict objectForKey: @"first_name"], [dataDict objectForKey:@"last_name"]];
                
                UILabel *valueLabel = [[UILabel alloc] initWithFrame: CGRectMake(124, 28 + labelCount * 24, 196, 20)];
                [valueLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
                [valueLabel setText: name];
                [nameLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
                [scrollView addSubview: valueLabel];
                
                labelCount++;
            }
        }else{*/
        if([dataDict objectForKey: [keys objectAtIndex: i]]){
            UILabel *keyLabel = [[UILabel alloc] initWithFrame: CGRectMake(24, nameHeight + labelCount * rowHeight, [self.view bounds].size.width / 2 - 24, rowHeight)];
            [keyLabel setTextColor: [UIColor colorWithRed:64/255.0f green: 114/255.0f blue:148/255.0f alpha:1.0f]];
            [keyLabel setTextAlignment: NSTextAlignmentCenter];
            [keyLabel setText: [NSString stringWithFormat: @"%@:", [englishNames objectAtIndex: i]]];
            [keyLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
            [scrollView addSubview: keyLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame: CGRectMake(164, nameHeight + labelCount * rowHeight, [self.view bounds].size.width / 2 - 24, rowHeight)];
            [valueLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
            [valueLabel setText: [dataDict objectForKey: [keys objectAtIndex: i]]];
            [valueLabel setFont: [UIFont fontWithName:@"OpenSans" size:16]];
            [valueLabel setAdjustsFontSizeToFitWidth: YES];
            [scrollView addSubview: valueLabel];
            
            labelCount++;
        }
        
        UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(19, nameHeight + (labelCount - 1) * rowHeight, [self.view bounds].size.width - 38, 1)];
        [divider setBackgroundColor: [UIColor colorWithRed:64/255.0f green: 114/255.0f blue:148/255.0f alpha:1.0f]];
        [scrollView addSubview: divider];
    }
    
    UIView *background = [[UIView alloc] initWithFrame: CGRectMake(20, nameHeight, [self.view bounds].size.width - 40, labelCount * rowHeight)];
    [background setBackgroundColor: [UIColor colorWithRed:231/255.0 green:239/255.0 blue:248/255.0 alpha:1.0]];
    [scrollView addSubview: background];
    [scrollView sendSubviewToBack: background];
    
    UIView *centralDivider = [[UIView alloc] initWithFrame: CGRectMake([self.view bounds].size.width / 2, nameHeight, 1, labelCount * rowHeight)];
    [centralDivider setBackgroundColor: [UIColor colorWithRed:64/255.0f green: 114/255.0f blue:148/255.0f alpha:1.0f]];
    [scrollView addSubview: centralDivider];
    
    [backButton setFrame: CGRectMake(20, nameHeight + 8 + labelCount * rowHeight, [self.view bounds].size.width - 40, backButton.frame.size.height)];
    [scrollView setContentSize: CGSizeMake(self.view.frame.size.width, backButton.frame.origin.y + backButton.frame.size.height + 8)];
}

- (IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
