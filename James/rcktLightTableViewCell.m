//
//  rcktLightTableViewCell.m
//  James
//
//  Created by Modesty & Roland on 31/08/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktLightTableViewCell.h"

@implementation rcktLightTableViewCell

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
        
 //   [self.action addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.onOff addTarget:self action:@selector(didSwitchOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(didSlider:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.colorTap addTarget:self action:@selector(didTapColor:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)didTapButton:(id)sender
//{
//    if (self.didTapButtonBlock) {
//        self.didTapButtonBlock(sender);
//    }
//}

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
