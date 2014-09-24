//
//  rcktLightTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 31/08/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktLightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UILabel *txt;
//@property (weak, nonatomic) IBOutlet UIButton *action;
@property (weak, nonatomic) IBOutlet UISwitch *onOff;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *color;
@property (weak, nonatomic) IBOutlet UIButton *colorTap;

//@property (copy, nonatomic) void (^didTapColorBlock)(id sender);
@property (copy, nonatomic) void (^didSwitchOnOffBlock)(id sender);
@property (copy, nonatomic) void (^didSliderBlock)(id sender);
@property (copy, nonatomic) void (^didTapColorBlock)(id sender);

//- (void)setDidTapColorBlock:(void (^)(id sender))didTapColorBlock;
- (void)setDidSwitchOnOffBlock:(void (^)(id sender))didSwitchOnOffBlock;
- (void)setDidSliderBlock:(void (^)(id sender))didSliderBlock;
- (void)setDidTapColorBlock:(void (^)(id sender))didTapColorBlock;


@end
