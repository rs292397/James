//
//  rcktPickerTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 05/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktPickerTableViewCell.h"

@implementation rcktPickerTableViewCell

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
