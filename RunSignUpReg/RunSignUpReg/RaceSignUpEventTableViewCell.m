//
//  RaceSignUpEventTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/17/13.
//
//

#import "RaceSignUpEventTableViewCell.h"

@implementation RaceSignUpEventTableViewCell
@synthesize nameLabel;
@synthesize priceLabel;
@synthesize priceLabel2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 0, 320, 20)];
        [nameLabel setFont: [UIFont boldSystemFontOfSize: 18.0f]];
        [self.contentView addSubview: nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 24, 312, 18)];
        [priceLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [priceLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel];
        
        self.priceLabel2 = [[UILabel alloc] initWithFrame: CGRectMake(4, 24, 312, 18)];
        [priceLabel2 setFont: [UIFont systemFontOfSize: 16.0f]];
        [priceLabel2 setTextColor: [UIColor colorWithRed:59/255.0f green:184/255.0f blue:224/255.0f alpha:1.0f]];
        [self.contentView addSubview: priceLabel2];
    }
    return self;
}

- (void)setPrice:(NSString *)price1 price2:(NSString *)price2{
    [priceLabel setText: [NSString stringWithFormat:@"%@ Race Fee", price1]];
    if(![price2 isEqualToString:@"$0.00"]){
        CGSize size = [[priceLabel text] sizeWithFont: [priceLabel font]];
        [priceLabel2 setText: [NSString stringWithFormat:@"+ %@ SignUp Fee", price2]];
        [priceLabel2 setFrame: CGRectMake([priceLabel frame].origin.x + size.width + 4, 24, 320 - [priceLabel frame].origin.x + size.width, 18)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
