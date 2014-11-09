//
//  rcktDeviceTokenFormsheet.h
//  James
//
//  Created by Modesty & Roland on 03/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktDeviceTokenFormsheet : UIViewController {
    NSDictionary *settings;
    NSArray *settingSectionTitles;

}

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;

@end
