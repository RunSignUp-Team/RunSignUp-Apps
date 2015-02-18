//
//  RaceSearchTableViewCell.m
//  RunSignUpReg
//
//  Created by Billy Connolly on 7/7/14.
//
//

#import "RaceSearchTableViewCell.h"

@implementation RaceSearchTableViewCell
@synthesize delegate;
@synthesize searchField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;

        self.searchField = [[UITextField alloc] initWithFrame: CGRectMake(8, 8, screenWidth - 16, 28)];
        [searchField setBorderStyle: UITextBorderStyleRoundedRect];
        [searchField setClearButtonMode: UITextFieldViewModeWhileEditing];
        [searchField setReturnKeyType: UIReturnKeySearch];
        [searchField setDelegate: self];
        [searchField setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        
        paddingView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, screenWidth / 2, 44)];
        [searchField setLeftView: paddingView];
        [searchField setLeftViewMode: UITextFieldViewModeAlways];        
        [self.contentView addSubview: searchField];
        
        searchGlass = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"SearchMagnifyingGlass.png"]];
        [searchGlass setFrame: CGRectMake([self frame].size.width / 2 - 10, 0, 20, 44)];
        [searchGlass setContentMode: UIViewContentModeScaleAspectFit];
        [self.contentView addSubview: searchGlass];
        
        /*advancedButton = [[UIButton alloc] initWithFrame: CGRectMake(320, 0, 28, 44)];
        [advancedButton setImage:[UIImage imageNamed:@"Gears.png"] forState:UIControlStateNormal];
        [advancedButton addTarget:self action:@selector(advanced) forControlEvents:UIControlEventTouchUpInside];
        [advancedButton setAdjustsImageWhenHighlighted: NO];
        //[advancedButton setBackgroundColor: [UIColor redColor]];
        [self.contentView addSubview: advancedButton];*/
        
        cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(screenWidth + 30, 0, 80, 44)];
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f] forState:UIControlStateNormal];
        //[cancelButton setBackgroundColor: [UIColor redColor]];
        [self.contentView addSubview: cancelButton];
        
        startEditButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, screenWidth, 44)];
        [startEditButton addTarget:self action:@selector(startEdit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: startEditButton];
        
        [self.contentView setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
    }
    return self;
}

- (void)makeTextFieldFirstResponder{
    [searchField becomeFirstResponder];
}

- (void)layoutActive:(BOOL)active{
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;

    if(active){
        [searchField setFrame: CGRectMake(8, 8, screenWidth - 90, 28)];
        [cancelButton setFrame: CGRectMake(screenWidth - 80, 0, 80, 44)];
        [searchGlass setFrame: CGRectMake(10, 0, 20, 44)];
        [paddingView setFrame: CGRectMake(0, 0, 18, 44)];
        [startEditButton setHidden: YES];
    }else{
        [searchField setFrame: CGRectMake(8, 8, screenWidth - 16, 28)];
        [cancelButton setFrame: CGRectMake(screenWidth + 30, 0, 80, 44)];
        [searchGlass setFrame: CGRectMake(screenWidth / 2 - 10, 0, 20, 44)];
        [paddingView setFrame: CGRectMake(0, 0, screenWidth / 2, 44)];
        [searchField setText: @""];
        [startEditButton setHidden: NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"SearchSlide" context:nil];
    [UIView setAnimationDuration: 0.2f];
    [self layoutActive: YES];
    [UIView commitAnimations];
    [delegate searchFieldDidBeginEdit];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:@"SearchSlide" context:nil];
    [UIView setAnimationDuration: 0.2f];
    [self layoutActive: NO];
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *stringToBe = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [delegate searchFieldDidEditText: stringToBe];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [delegate searchButtonTappedWithSearch: [searchField text]];
    return NO;
}

- (void)startEdit{
    [searchField becomeFirstResponder];
}

- (void)cancel{
    [searchField resignFirstResponder];
    [delegate searchFieldDidCancel];
}

@end
