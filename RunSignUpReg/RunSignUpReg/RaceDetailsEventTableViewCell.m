//
//  RaceDetailsEventTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 12/22/12.
//
//

#import "RaceDetailsEventTableViewCell.h"

@implementation RaceDetailsEventTableViewCell
@synthesize nameLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 0, 100, 22)];
        [nameLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, 0, 100, 22)];
        [timeLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [nameLabel sizeToFit];
    CGFloat x = MIN(nameLabel.frame.origin.x + nameLabel.frame.size.width + 2, 230);
    if(x == 230)
        [nameLabel setFrame: CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 230, nameLabel.frame.size.height)];
    [timeLabel setFrame: CGRectMake(x, 0, 316 - x, 20)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
