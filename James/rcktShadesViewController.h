//
//  rcktShadesViewController.h
//  James
//
//  Created by Modesty & Roland on 20/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktShadesViewController : UIViewController {
    UIRefreshControl *refreshControl;
    NSString *urlServer;
}

@property (nonatomic, strong) NSMutableArray *shadesArray;
@property (strong, nonatomic) IBOutlet UITableView *shadesTableView;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
