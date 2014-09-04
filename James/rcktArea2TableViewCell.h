//
//  rcktArea2TableViewCell.h
//  James
//
//  Created by Modesty & Roland on 25/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktArea2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *areaDescription;
@property (weak, nonatomic) IBOutlet UIButton *areaAction;
@property (weak, nonatomic) IBOutlet UISwitch *areaOnOff;
@property (weak, nonatomic) IBOutlet UISlider *areaSlider;
@property (weak, nonatomic) IBOutlet UIView *areaColor;
@property (weak, nonatomic) IBOutlet UIButton *areaColorTap;

@property (copy, nonatomic) void (^didTapButtonBlock)(id sender);
@property (copy, nonatomic) void (^didSwitchOnOffBlock)(id sender);
@property (copy, nonatomic) void (^didSliderBlock)(id sender);
@property (copy, nonatomic) void (^didTapColorBlock)(id sender);

- (void)setDidTapButtonBlock:(void (^)(id sender))didTapButtonBlock;
- (void)setDidSwitchOnOffBlock:(void (^)(id sender))didSwitchOnOffBlock;
- (void)setDidSliderBlock:(void (^)(id sender))didSliderBlock;
- (void)setDidTapColorBlock:(void (^)(id sender))didTapColorBlock;

@end
