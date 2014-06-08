//
//  RaceResultsEventDetailsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/1/14.
//
//

#import "RaceResultsEventDetailsViewController.h"

@implementation RaceResultsEventDetailsViewController
@synthesize scrollView;

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
    NSArray *keys = @[@"place", @"bib", @"name", @"gender", @"state", @"country_code", @"pace", @"clock_time", @"age", @"age_percentage"];
    NSArray *englishNames = @[@"Place", @"Bib", @"Name", @"Gender", @"State", @"Country", @"Pace", @"Time", @"Age", @"Age %"];
    
    int labelCount = 0;
    for(int i = 0; i < [keys count]; i++){
        if([[keys objectAtIndex: i] isEqualToString: @"name"]){
            if([dataDict objectForKey:@"first_name"] && [dataDict objectForKey:@"last_name"]){
                UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4 + labelCount * 24, 116, 20)];
                [nameLabel setTextColor: [UIColor colorWithRed:0.0f green: 148/255.0f blue:204/255.0f alpha:1.0f]];
                [nameLabel setText: @"Name:"];
                [scrollView addSubview: nameLabel];
                
                NSString *name = [NSString stringWithFormat: @"%@ %@", [dataDict objectForKey: @"first_name"], [dataDict objectForKey:@"last_name"]];
                
                UILabel *valueLabel = [[UILabel alloc] initWithFrame: CGRectMake(124, 4 + labelCount * 24, 196, 20)];
                [valueLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
                [valueLabel setText: name];
                [scrollView addSubview: valueLabel];
                
                labelCount++;
            }
        }else{
            if([dataDict objectForKey: [keys objectAtIndex: i]]){
                UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4 + labelCount * 24, 116, 20)];
                [nameLabel setTextColor: [UIColor colorWithRed:0.0f green: 148/255.0f blue:204/255.0f alpha:1.0f]];
                [nameLabel setText: [NSString stringWithFormat: @"%@:", [englishNames objectAtIndex: i]]];
                [scrollView addSubview: nameLabel];
                
                UILabel *valueLabel = [[UILabel alloc] initWithFrame: CGRectMake(124, 4 + labelCount * 24, 196, 20)];
                [valueLabel setTextColor: [UIColor colorWithRed:0.8706f green:0.6704f blue:0.298f alpha:1.0f]];
                [valueLabel setText: [dataDict objectForKey: [keys objectAtIndex: i]]];
                [scrollView addSubview: valueLabel];
                
                labelCount++;
            }
        }
    }
    
    [scrollView setContentSize: CGSizeMake(self.view.frame.size.width, 4 + labelCount * 24 + 4)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
