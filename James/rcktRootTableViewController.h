//
//  rcktRootTableViewController.h
//  James
//
//  Created by Modesty & Roland on 17/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktRootTableViewController : UITableViewController {
    NSDictionary *rootItems;
    NSArray *rootItemSectionTitles;
}

@property (strong, nonatomic) IBOutlet UITableView *rootTableView;

@end
