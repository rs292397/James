//
//  rcktSceneTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 04/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSceneTableViewCell.h"

@implementation rcktSceneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self.sceneTap addTarget:self action:@selector(didTapScene:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapScene:(id)sender
{
    if (self.didTapSceneBlock) {
        self.didTapSceneBlock(sender);
    }
}

@end
