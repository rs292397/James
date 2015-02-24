//
//  rcktScenariosDetailViewController.h
//  James
//
//  Created by Modesty & Roland on 19/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rckt.h" 

@interface rcktScenariosDetailViewController : UIViewController {
    rckt *r;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) NSMutableArray *scenariosArray;
@property (strong, nonatomic) IBOutlet UITableView *scenariosTableView;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@end
