//
//  rcktSceneTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 04/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktSceneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UILabel *description;

@property (weak, nonatomic) IBOutlet UIButton *sceneTap;
@property (copy, nonatomic) void (^didTapSceneBlock)(id sender);
- (void)setDidTapSceneBlock:(void (^)(id sender))didTapSceneBlock;


@end
