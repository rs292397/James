//
//  rcktShadeTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 20/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktShadeTableViewCell.h"

@implementation rcktShadeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [self.cmdOpen addTarget:self action:@selector(didTapOpen:) forControlEvents: UIControlEventTouchUpInside];
    [self.cmdClose addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapOpen:(id)sender
{
    if (self.didTapOpenBlock) {
        self.didTapOpenBlock(sender);
    }
}
- (void)didTapClose:(id)sender
{
    if (self.didTapCloseBlock) {
        self.didTapCloseBlock(sender);
    }
}

@end
