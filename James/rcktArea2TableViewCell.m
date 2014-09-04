//
//  rcktArea2TableViewCell.m
//  James
//
//  Created by Modesty & Roland on 25/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktArea2TableViewCell.h"




@implementation rcktArea2TableViewCell



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
    [super awakeFromNib];
    
    [self.areaAction addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.areaOnOff addTarget:self action:@selector(didSwitchOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [self.areaSlider addTarget:self action:@selector(didSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.areaColorTap addTarget:self action:@selector(didTapColor:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapButton:(id)sender
{
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}

- (void)didTapColor:(id)sender
{
    if (self.didTapColorBlock) {
        self.didTapColorBlock(sender);
    }
}

- (void)didSwitchOnOff:(id)sender
{
    if (self.didSwitchOnOffBlock) {
        self.didSwitchOnOffBlock(sender);
    }
}

- (void)didSlider:(id)sender
{
    if (self.didSliderBlock) {
        self.didSliderBlock(sender);
    }
}
@end
