//
//  RaceDetailsEventTableViewCell.m
//  RunSignUpReg
//
// Copyright 2014 RunSignUp
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

#import "RaceDetailsEventTableViewCell.h"

@implementation RaceDetailsEventTableViewCell
@synthesize nameLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(4, 0, 100, 22)];
        [nameLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, 0, 100, 22)];
        [timeLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self.contentView addSubview: timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [nameLabel sizeToFit];
    CGFloat x = MIN(nameLabel.frame.origin.x + nameLabel.frame.size.width + 2, 230);
    if(x == 230)
        [nameLabel setFrame: CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 230, nameLabel.frame.size.height)];
    [timeLabel setFrame: CGRectMake(x, 0, 316 - x, 20)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
