//
//  RaceSearchRoundedTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import "RaceSearchRoundedTableViewCell.h"

@implementation RaceSearchRoundedTableViewCell
@synthesize top,bottom,extra;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        roundedImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"RaceSearchRoundMiddle.png"]];
        [roundedImage setFrame: CGRectMake(20, 0, 280, 64)];
        [self.contentView addSubview: roundedImage];
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
    
    [self.contentView addSubview: roundedImage];
    
    [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundMiddle.png"]];
    
    if(!self.extra){
        [roundedImage setHidden: NO];
        if(self.top){
            [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundTop.png"]];
        }else if(self.bottom){
            [roundedImage setImage: [UIImage imageNamed:@"RaceSearchRoundBottom.png"]];
        }
        
        if(self.middleDivider){
            UIView *divider = [[UIView alloc] initWithFrame: CGRectMake([self frame].size.width / 2, 0, 1, [self frame].size.height)];
            [divider setBackgroundColor: [UIColor colorWithRed:99/255.0f green:135/255.0f blue:165/255.0f alpha:1.0f]];
            [self.contentView addSubview:divider];
        }
    }else{
        [roundedImage setHidden: YES];
    }
}

@end
