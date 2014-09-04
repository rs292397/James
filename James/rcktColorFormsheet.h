//
//  rcktColorFormsheet.h
//  James
//
//  Created by Modesty & Roland on 02/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DRColorPickerBaseViewController.h"

@interface rcktColorFormsheet : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (weak, nonatomic) IBOutlet UIView *hueWheel;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void)setParams:(NSString *)lightId cHue:(float) hue cSat:(float) sat;

@end
