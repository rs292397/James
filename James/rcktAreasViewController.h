//
//  rcktAreasViewController.h
//  James
//
//  Created by Modesty & Roland on 25/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktAreasViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *areasDescription;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSString *key;

@end
