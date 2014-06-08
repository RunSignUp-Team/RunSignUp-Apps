//
//  RaceSignUpQuestionsTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 6/5/14.
//
//

#import "RaceSignUpQuestionsTableViewCell.h"

@implementation RaceSignUpQuestionsTableViewCell
@synthesize questionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.questionLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 8, 312, 20)];
        [questionLabel setFont: [UIFont systemFontOfSize: 18.0f]];
        
        [self.contentView addSubview: questionLabel];
    }
    return self;
}

- (void)setType:(RSUQuestionType)t{
    type = t;
    
    for(UIView *subview in self.contentView.subviews){
        if(subview != questionLabel){
            [subview release];
        }
    }
    
    if(t == RSUQuestionTypeFreeform){
        freeformField = [[UITextField alloc] initWithFrame: CGRectMake(8, 34, 304, 30)];
        [freeformField setBorderStyle: UITextBorderStyleRoundedRect];
        [freeformField setReturnKeyType: UIReturnKeyNext];
        [self.contentView addSubview: freeformField];
    }else if(t == RSUQuestionTypeBoolean){
        
    }
}

- (RSUQuestionType)type{
    return type;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
