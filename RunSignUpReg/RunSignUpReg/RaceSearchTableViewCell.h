//
//  RaceSearchTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import <UIKit/UIKit.h>

@protocol RaceSearchTableViewCellDelegate <NSObject>

- (void)searchFieldDidBeginEdit;
- (void)searchFieldDidCancel;
- (void)searchButtonTappedWithSearch:(NSString *)search;

@end

@interface RaceSearchTableViewCell : UITableViewCell <UITextFieldDelegate>{
    UITextField *searchField;
    UIImageView *searchGlass;
    UIButton *cancelButton;
    UIButton *startEditButton;
    
    UIView *paddingView;
    
    NSObject<RaceSearchTableViewCellDelegate> *delegate;
}

@property (nonatomic, retain) NSObject<RaceSearchTableViewCellDelegate> *delegate;

- (void)setActiveSearch;

@end
