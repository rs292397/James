//
//  rcktSwitchTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 14/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktSwitchTableViewCell.h"

@implementation rcktSwitchTableViewCell

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
    [self.swtch addTarget:self action:@selector(didSwitchOnOff:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didSwitchOnOff:(id)sender
{
    if (self.didSwitchOnOffBlock) {
        self.didSwitchOnOffBlock(sender);
    }
}

@end
