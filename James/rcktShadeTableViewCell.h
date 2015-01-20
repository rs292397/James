//
//  rcktShadeTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 20/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktShadeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *cmdOpen;
@property (weak, nonatomic) IBOutlet UIButton *cmdClose;

@property (copy, nonatomic) void (^didTapOpenBlock)(id sender);
@property (copy, nonatomic) void (^didTapCloseBlock)(id sender);

- (void)setDidTapOpenBlock:(void (^)(id sender))didTapOpenBlock;
- (void)setDidTapCloseBlock:(void (^)(id sender))didTapCloseBlock;

@end
