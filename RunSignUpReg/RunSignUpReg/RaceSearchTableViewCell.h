//
//  RaceSearchTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import <UIKit/UIKit.h>

@protocol RaceSearchTableViewCellDelegate <NSObject>

- (void)searchButtonTappedWithSearch:(NSString *)search;
- (void)advancedSearchTappedWithSearch:(NSString *)search;

@end

@interface RaceSearchTableViewCell : UITableViewCell <UITextFieldDelegate>{
    UITextField *searchField;
    UIImageView *searchGlass;
    UIButton *cancelButton;
    UIButton *advancedButton;
    UIButton *startEditButton;
        
    NSObject<RaceSearchTableViewCellDelegate> *delegate;
}

@property (nonatomic, retain) NSObject<RaceSearchTableViewCellDelegate> *delegate;

@end
