//
//  RaceSignUpCartTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 8/12/13.
//
//

#import "RaceSignUpCartTableViewCell.h"

@implementation RaceSignUpCartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        infoLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 4, 250, 20)];
        [infoLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: infoLabel];
        
        totalCostLabel = [[UILabel alloc] initWithFrame: CGRectMake(252, 4, 64, 20)];
        [totalCostLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [totalCostLabel setTextColor: [UIColor colorWithRed:222/255.0f green:171/255.0f blue:76/255.0f alpha:1.0f]];
        [self.contentView addSubview: totalCostLabel];
        
        subitemsLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 28, 312, 20)];
        [subitemsLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: subitemsLabel];
    }
    return self;
}

- (void)setInfo:(NSString *)info total:(NSString *)total subitems:(NSString *)subitems{
    [infoLabel setText: info];
    [totalCostLabel setText: total];
    [subitemsLabel setText: [NSString stringWithFormat:@"  • %@", subitems]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
