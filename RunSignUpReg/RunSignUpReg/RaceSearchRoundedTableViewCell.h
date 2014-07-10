//
//  RaceSearchRoundedTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import <UIKit/UIKit.h>

@interface RaceSearchRoundedTableViewCell : UITableViewCell{
    UIImageView *roundedImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(float)height;

@property(nonatomic,assign) BOOL top,bottom,extra,middleDivider;

- (void)reset;

@end
