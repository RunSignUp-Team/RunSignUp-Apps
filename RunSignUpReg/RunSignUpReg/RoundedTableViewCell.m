//
//  RaceSearchRoundedTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import "RoundedTableViewCell.h"

@implementation RoundedTableViewCell
@synthesize top,bottom,extra,middleDivider;
@synthesize cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;

        roundedImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"RaceSearchRoundMiddle.png"]];
        [roundedImage setFrame: CGRectMake(20, 0, screenWidth - 40, 0)];
        [self.contentView addSubview: roundedImage];
        [self.contentView sendSubviewToBack: roundedImage];
        
        [self.contentView setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
        //[self.contentView setBackgroundColor: [UIColor colorWithRed:40/255.0f green:164/255.0f blue:219/255.0f alpha:1.0f]];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)reset{
    for(UIView *view in self.contentView.subviews){
        [view removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self.contentView addSubview: roundedImage];
    [self.contentView sendSubviewToBack: roundedImage];
    
    [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundMiddle.png"]];
    [roundedImage setFrame: CGRectMake(20, 0, screenWidth - 40, cellHeight)];
    
    if(!self.extra){
        [roundedImage setHidden: NO];
        if(self.top){
            [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundTop.png"]];
        }else if(self.bottom){
            [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundBottom.png"]];
        }
        
        if(self.middleDivider){
            UIView *divider = [[UIView alloc] initWithFrame: CGRectMake(screenWidth / 2, 0, 1, cellHeight)];
            [divider setBackgroundColor: [UIColor colorWithRed:99/255.0f green:135/255.0f blue:165/255.0f alpha:1.0f]];
            [self.contentView addSubview:divider];
        }
    }else{
        [roundedImage setHidden: YES];
    }
}

@end
