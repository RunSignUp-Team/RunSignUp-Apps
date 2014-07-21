//
//  RoundedLoadingIndicator.m
//  RunSignUp
//
// Copyright 2012 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RoundedLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedLoadingIndicator
@synthesize activity;
@synthesize label;

- (id)initWithXLocation:(int)locX YLocation:(int)locY{
    self = [super initWithFrame:CGRectMake(locX, locY, 160, 100)];
    if(self){
        //self.activity = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(62, 20, 36, 36)];
        self.label = [[UILabel alloc] initWithFrame: CGRectMake(5, 70, 150, 20)];
        [label setFont: [UIFont fontWithName:@"OpenSans" size:16]];
        
        /*[activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [activity setBackgroundColor: [UIColor clearColor]];
        [activity startAnimating];
        [self addSubview: activity];*/
        
        UIImageView *loadingView = [[UIImageView alloc] initWithFrame: CGRectMake(44, 2, 72, 72)];
        NSMutableArray *animationImages = [[NSMutableArray alloc] init];
        for(int x = 1; x < 26; x++){
            [animationImages addObject: [UIImage imageNamed: [NSString stringWithFormat:@"loading%i", x]]];
        }
        [loadingView setAnimationImages: animationImages];
        [loadingView setAnimationDuration:1.0f];
        [loadingView startAnimating];
        [self addSubview: loadingView];
        
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f]];
        [label setTextAlignment: NSTextAlignmentCenter];
        [label setText: @"Signing in..."];
        [self addSubview: label];
        
        [self setBackgroundColor: [UIColor colorWithRed:231/255.0f green:239/255.0f blue:248/255.0f alpha:1.0f]];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(1, 0);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = .25;
        self.layer.borderColor = [[UIColor colorWithRed:64/255.0f green:114/255.0f blue:145/255.0f alpha:1.0f] CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self setHidden: YES];
        [self setAlpha: 0.0f];
    }
    return self;
}

- (void)fadeIn{
    [self setAlpha: 0.0f];
    [self setHidden: NO];
    [UIView beginAnimations:@"RLI Fade" context:nil];
    [UIView setAnimationDuration:0.25f];
    [self setAlpha: 1.0f];
    [UIView commitAnimations];
}

- (void)fadeOut{
    //[self setAlpha: 1.0f];
    [self setHidden: NO];
    [UIView beginAnimations:@"RLI Fade" context:nil];
    [UIView setAnimationDuration:0.25f];
    [self setAlpha: 0.0f];
    [UIView commitAnimations];
    [self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
