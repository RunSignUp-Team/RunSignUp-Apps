//
//  RaceResultsEventTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/8/13.
//
//

#import "RaceResultsEventTableViewCell.h"

@implementation RaceResultsEventTableViewCell
@synthesize placeLabel;
@synthesize bibLabel;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize genderLabel;
@synthesize timeLabel;
@synthesize paceLabel;
@synthesize ageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int widths[] = {40, 40, 86, 38, 40, 37, 32};
        int cumWidth = 4;
        for(int x = 0; x <= 7; x++){
            UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(cumWidth, 0, 1, [self frame].size.height)];
            [divider setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
            [self.contentView addSubview: divider];
            [divider release];
            
            cumWidth += widths[x];
        }
        
        float fontSize = 11.0f;
        float labelHeight = self.frame.size.height / 2.0f - (fontSize + 2.0f) / 2.0f;
        
        UIView *separator = [[UIView alloc] initWithFrame: CGRectMake(4, [self frame].size.height - 1, [self frame].size.width - 8, 1)];
        [separator setBackgroundColor: [UIColor colorWithRed:189/255.0f green:219/255.0f blue:229/255.0f alpha:1.0f]];
        [self.contentView addSubview: separator];
        [separator release];
        
        self.placeLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, labelHeight, 33, fontSize + 2)];
        self.bibLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, labelHeight, 33, fontSize + 2)];
        self.firstNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(90, labelHeight - (fontSize + 2.0f) / 2.0f - 2, 78, fontSize + 2)];
        self.lastNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(90, labelHeight + (fontSize + 2.0f) / 2.0f + 2, 78, fontSize + 2)];
        self.genderLabel = [[UILabel alloc] initWithFrame: CGRectMake(175, labelHeight, 31, fontSize + 2)];
        self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(213, labelHeight, 33, fontSize + 2)];
        self.paceLabel = [[UILabel alloc] initWithFrame: CGRectMake(253, labelHeight, 30, fontSize + 2)];
        self.ageLabel = [[UILabel alloc] initWithFrame: CGRectMake(290, labelHeight, 25, fontSize + 2)];
        
        [placeLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [bibLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [firstNameLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [lastNameLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [genderLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [timeLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [paceLabel setFont: [UIFont systemFontOfSize: fontSize]];
        [ageLabel setFont: [UIFont systemFontOfSize: fontSize]];
        
        [placeLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [bibLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [firstNameLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [lastNameLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [genderLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [timeLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [paceLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        [ageLabel setTextColor: [UIColor colorWithRed:47/255.0f green:132/255.0f blue:165/255.0f alpha:1.0f]];
        
        //self.bibLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, labelHeight, 25, fontSize + 2)];
        //self.bibLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, labelHeight, 25, fontSize + 2)];
        
        /*[placeLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [bibLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [firstNameLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [lastNameLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [genderLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [timeLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [paceLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        [ageLabel setBackgroundColor: [UIColor colorWithRed:(rand() % 255) / 255.0f green:(rand() % 255) / 255.0f blue:(rand() % 255) / 255.0f alpha:1.0f]];
        */
        [self.contentView addSubview: placeLabel];
        [self.contentView addSubview: bibLabel];
        [self.contentView addSubview: firstNameLabel];
        [self.contentView addSubview: lastNameLabel];
        [self.contentView addSubview: genderLabel];
        [self.contentView addSubview: timeLabel];
        [self.contentView addSubview: paceLabel];
        [self.contentView addSubview: ageLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
