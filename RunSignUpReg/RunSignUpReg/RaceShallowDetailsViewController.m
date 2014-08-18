//
//  RaceShallowDetailsViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/28/14.
//
//

#import "RaceShallowDetailsViewController.h"
#import "RSUModel.h"
#import "RSUWebViewController.h"

@implementation RaceShallowDetailsViewController
@synthesize allViews;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize dateLabel;
@synthesize typeLabel;
@synthesize viewRaceButton;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Details";
        dataDict = data;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *darkBlueButtonImage = [UIImage imageNamed:@"DarkBlueButton.png"];
    UIImage *stretchedDarkBlueButton = [darkBlueButtonImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *darkBlueButtonTapImage = [UIImage imageNamed:@"DarkBlueButtonTap.png"];
    UIImage *stretchedDarkBlueButtonTap = [darkBlueButtonTapImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];

    [backButton setBackgroundImage:stretchedDarkBlueButton forState:UIControlStateNormal];
    [backButton setBackgroundImage:stretchedDarkBlueButtonTap forState:UIControlStateHighlighted];
    
    [nameLabel setFont: [UIFont fontWithName:@"Sanchez-Regular" size:20]];
    [locationLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
    [dateLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
    [typeLabel setFont: [UIFont fontWithName:@"OpenSans" size:18]];
    
    [[viewRaceButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:18]];
    [[backButton titleLabel] setFont: [UIFont fontWithName:@"Sanchez-Regular" size:24]];
    
    [nameLabel setText: [dataDict objectForKey: @"name"]];
    [locationLabel setText: [RSUModel addressLine2FromAddress: [dataDict objectForKey:@"address"]]];

    if([dataDict objectForKey: @"next_date"])
        [dateLabel setText: [dataDict objectForKey: @"next_date"]];
    else if([dataDict objectForKey: @"last_date"])
        [dateLabel setText: [dataDict objectForKey: @"last_date"]];

    [typeLabel setText: @"5k, 2 Mile"];
    
    CGSize reqSize = [[nameLabel text] sizeWithFont:[nameLabel font] constrainedToSize:CGSizeMake(280, INFINITY) lineBreakMode:NSLineBreakByWordWrapping];
    [nameLabel setFrame: CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 280, reqSize.height)];
    [allViews setFrame: CGRectMake(allViews.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 8, allViews.frame.size.width, allViews.frame.size.height)];
    [backButton setFrame: CGRectMake(backButton.frame.origin.x, allViews.frame.origin.y + allViews.frame.size.height + 8, backButton.frame.size.width, backButton.frame.size.height)];
}

- (IBAction)viewRacePage:(id)sender{
    NSString *url = [dataDict objectForKey: @"url"];
    if(url){
        RSUWebViewController *rsuwvc = [[RSUWebViewController alloc] initWithURL: [NSURL URLWithString: url]];
        [self presentViewController:rsuwvc animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Race does not have a race page" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
