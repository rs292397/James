//
//  rcktLabelCollectionViewCell.h
//  James
//
//  Created by Modesty & Roland on 15/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktLabelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *tap;

@property (copy, nonatomic) void (^didTapBlock)(id sender);

- (void)setDidTapBlock:(void (^)(id sender))didTapBlock;

@end
