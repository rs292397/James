//
//  rcktDoorbellViewController.h
//  James
//
//  Created by Modesty & Roland on 13/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktDoorbellViewController : UIViewController {
    NSString *urlServer;
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (nonatomic, strong) NSMutableArray *messagesArray;
@property (strong, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

-(IBAction)switchNtoficationChange:(id)sender;


@end
