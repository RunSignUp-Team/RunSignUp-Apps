//
//  RaceSignUpMembershipsTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/9/14.
//
//

#import "RaceSignUpMembershipsTableViewCell.h"

@implementation RaceSignUpMembershipsTableViewCell
@synthesize nameLabel;
@synthesize priceAdjLabel;
@synthesize additionalFieldHint;
@synthesize additionalField;
@synthesize optionalNoticeLabel;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 17, 312, 20)];
        [nameLabel setFont: [UIFont systemFontOfSize: 18]];
        [nameLabel setAdjustsFontSizeToFitWidth: YES];
        [nameLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: nameLabel];
        
        self.additionalFieldHint = [[UILabel alloc] initWithFrame: CGRectMake(4, 40, 312, 20)];
        [additionalFieldHint setFont: [UIFont systemFontOfSize: 18]];
        [additionalFieldHint setAlpha: 0.0f];
        [self.contentView addSubview: additionalFieldHint];
        
        self.additionalField = [[UITextField alloc] initWithFrame: CGRectMake(4, 64, 312, 30)];
        [additionalField setAlpha: 0.0f];
        [additionalField setBorderStyle: UITextBorderStyleRoundedRect];
        [self.contentView addSubview: additionalField];
        
        self.optionalNoticeLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 100, 312, 30)];
        [optionalNoticeLabel setNumberOfLines: 0];
        [optionalNoticeLabel setLineBreakMode: NSLineBreakByWordWrapping];
        [optionalNoticeLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        [self.contentView addSubview: optionalNoticeLabel];
        
        active = NO;
    }
    return self;
}

- (void)setActive:(BOOL)a{
    active = a;
    [UIView beginAnimations:@"Active" context:nil];
    if(active){
        [nameLabel setFrame: CGRectMake(4, 8, 312, 20)];
        [additionalFieldHint setAlpha: 1.0f];
        [additionalField setAlpha: 1.0f];
    }else{
        [nameLabel setFrame: CGRectMake(4, 17, 312, 20)];
        [additionalFieldHint setAlpha: 0.0f];
        [additionalField setAlpha: 0.0f];
    }
    [UIView commitAnimations];
}

- (void)setOptionalNoticeText:(NSString *)text{
    CGSize requiredSize = [text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(312, INFINITY)];
    [optionalNoticeLabel setFrame: CGRectMake(4, 100, 312, requiredSize.height)];
    [optionalNoticeLabel setText: text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
