//
//  rcktCameraCollectionViewCell.h
//  James
//
//  Created by Modesty & Roland on 23/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktCameraCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UIWebView *cam;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *tap;

@property (copy, nonatomic) void (^didTapBlock)(id sender);

- (void)setDidTapBlock:(void (^)(id sender))didTapBlock;

@end
