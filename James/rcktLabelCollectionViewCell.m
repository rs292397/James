//
//  rcktLabelCollectionViewCell.m
//  James
//
//  Created by Modesty & Roland on 15/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktLabelCollectionViewCell.h"

@implementation rcktLabelCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {

    // Initialization code
    [super awakeFromNib];

    [self.tap addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didTap:(id)sender
{
    if (self.didTapBlock) {
        self.didTapBlock(sender);
    }
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
