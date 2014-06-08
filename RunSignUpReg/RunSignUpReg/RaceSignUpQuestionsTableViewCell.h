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

@interface RaceSignUpQuestionsTableViewCell : UITableViewCell{
    UILabel *questionLabel;
    RSUQuestionType type;
    
    UITextField *freeformField;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) UILabel *questionLabel;
@property RSUQuestionType type;

@end
