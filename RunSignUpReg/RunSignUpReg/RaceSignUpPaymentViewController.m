//
//  RaceSignUpPaymentViewController.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceSignUpPaymentViewController.h"
#import "RegistrantTableViewCell.h"

@implementation RaceSignUpPaymentViewController
@synthesize registrantsTable;
@synthesize registrationCartHintLabel;
@synthesize registrationCartTable;
@synthesize baseCostHintLabel;
@synthesize baseCostLabel;
@synthesize processingFeeHintLabel;
@synthesize processingFeeLabel;
@synthesize totalHintLabel;
@synthesize totalLabel;
@synthesize couponField;
@synthesize couponHintLabel;
@synthesize applyButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        dataDict = data;
        
        self.title = @"Payment";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIExtendedEdgeNone];
    
    UIImage *greenButtonImage = [UIImage imageNamed:@"GreenButton.png"];
    UIImage *stretchedGreenButton = [greenButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *greenButtonTapImage = [UIImage imageNamed:@"GreenButtonTap.png"];
    UIImage *stretchedGreenButtonTap = [greenButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [applyButton setBackgroundImage:stretchedGreenButton forState:UIControlStateNormal];
    [applyButton setBackgroundImage:stretchedGreenButtonTap forState:UIControlStateHighlighted];
    
    [self layoutContent];
}

- (void)layoutContent{
    int numberOfRegistrants = 1;
    int heightOfRegistrantCell = 248;
    
    int numberOfCartItems = 2;
    int heightOfCartCell = 44;
    
    [registrantsTable setFrame: CGRectMake(4, registrantsTable.frame.origin.y, 312, numberOfRegistrants * heightOfRegistrantCell)];
    [registrationCartHintLabel setFrame: CGRectMake(4, registrantsTable.frame.origin.y + registrantsTable.frame.size.height + 8, 312, registrationCartHintLabel.frame.size.height)];
    [registrationCartTable setFrame: CGRectMake(4, registrationCartHintLabel.frame.origin.y + registrationCartHintLabel.frame.size.height + 4, 312, numberOfCartItems * heightOfCartCell)];
    float baseCostY = registrationCartTable.frame.origin.y + registrationCartTable.frame.size.height + 4;
    [baseCostHintLabel setFrame: CGRectMake(4, baseCostY, 123, 18)];
    [baseCostLabel setFrame: CGRectMake(135, baseCostY, 181, 18)];
    [processingFeeHintLabel setFrame: CGRectMake(4, baseCostY + 22, 123, 18)];
    [processingFeeLabel setFrame: CGRectMake(135, baseCostY + 22, 181, 18)];
    [totalHintLabel setFrame: CGRectMake(4, baseCostY + 44, 123, 18)];
    [totalLabel setFrame: CGRectMake(135, baseCostY + 44, 181, 18)];
    [couponField setFrame: CGRectMake(4, totalHintLabel.frame.origin.y + totalLabel.frame.size.height + 4, 312, 31)];
    [couponHintLabel setFrame: CGRectMake(4, couponField.frame.origin.y + couponField.frame.size.height + 4, 312, 15)];
    [applyButton setFrame: CGRectMake(4, couponHintLabel.frame.origin.y + couponHintLabel.frame.size.height + 4, 312, 46)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == registrantsTable){
        static NSString *CellIdentifier = @"CellIdentifier";
        RegistrantTableViewCell *cell = (RegistrantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[RegistrantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [[cell textLabel] setText: @""];
        return cell;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == registrantsTable)
        return 248;
    else
        return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == registrantsTable)
        return 1;
    else
        return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)applyCoupon:(id)sender{
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
