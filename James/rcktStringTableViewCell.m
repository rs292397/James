//
//  rcktStringTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 17/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktStringTableViewCell.h"

@implementation rcktStringTableViewCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
