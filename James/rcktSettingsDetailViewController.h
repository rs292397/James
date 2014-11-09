//
//  rcktSettingsDetailViewController.h
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktSettingsDetailViewController : UIViewController {
    
    NSDictionary *settingsItems;
    NSArray *settingsItemSectionTitles;
}

@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;

@end
