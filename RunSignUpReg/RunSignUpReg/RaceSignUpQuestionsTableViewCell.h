//
//  RaceSignUpQuestionsTableViewCell.h
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    RSUQuestionTypeFreeform = 0,
    RSUQuestionTypeBoolean,
    RSUQuestionTypeSelection,
    RSUQuestionTypeRadio,
    RSUQuestionTypeCheck,
    RSUQuestionTypeTime
}RSUQuestionType;

@protocol RaceSignUpQuestionsTableViewCellDelegate <UITextFieldDelegate>

- (void)didChangeResponse:(id)response forQuestionID:(NSString *)questionID;

@end

@class RaceSignUpQuestionsViewController;

@interface RaceSignUpQuestionsTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>{
    UILabel *questionLabel;
    RSUQuestionType type;
    
    id questionID;
    
    NSArray *responses;
    NSMutableArray *selectedArray;
    
    UITextField *freeformField;
    UISegmentedControl *booleanControl;
    UITableView *selectionTable;
    UIPickerView *timePicker;
    
    NSObject<RaceSignUpQuestionsTableViewCellDelegate> *delegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) UILabel *questionLabel;
@property (nonatomic, retain) NSArray *responses;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) id questionID;
@property RSUQuestionType type;
@property (nonatomic, retain) NSObject<RaceSignUpQuestionsTableViewCellDelegate> *delegate;

- (void)setQuestionLabelText:(NSString *)text;
- (int)requiredHeight;

- (id)response;
- (void)valueDidChange;

- (void)hideKeyboard;

@end
