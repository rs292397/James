//
//  rcktSettingsDevicesViewController.h
//  James
//
//  Created by Modesty & Roland on 26/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rckt.h"



@interface rcktSettingsDevicesViewController : UIViewController {
    
    rckt *r;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) NSMutableArray *devicesArray;
@property (strong, nonatomic) IBOutlet UITableView *devicesTableView;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void) didEditObject;

@end
