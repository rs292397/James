//
//  rcktColorPickerView.h
//  James
//
//  Created by Modesty & Roland on 03/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktColorPickerView : UIView

@property (nonatomic, strong) UIColor* color;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void) initColor:(UIColor *) newColor lightID: (NSString *) l;
- (UIColor*) getColor;
- (void) sendColor;

@end
