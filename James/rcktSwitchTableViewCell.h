//
//  rcktSwitchTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 14/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UISwitch *swtch;

@property (copy, nonatomic) void (^didSwitchOnOffBlock)(id sender);
- (void)setDidSwitchOnOffBlock:(void (^)(id sender))didSwitchOnOffBlock;

@end
