//
//  RaceSearchRoundedTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import <UIKit/UIKit.h>

@interface RoundedTableViewCell : UITableViewCell{
    UIImageView *roundedImage;
    float cellHeight;
}

@property(nonatomic,assign) BOOL top,bottom,extra,middleDivider;
@property float cellHeight;

- (void)reset;

@end
