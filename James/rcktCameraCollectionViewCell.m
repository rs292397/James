//
//  rcktCameraCollectionViewCell.m
//  James
//
//  Created by Modesty & Roland on 23/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktCameraCollectionViewCell.h"

@implementation rcktCameraCollectionViewCell

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

@end
