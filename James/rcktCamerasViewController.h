//
//  rcktCamerasViewController.h
//  James
//
//  Created by Modesty & Roland on 09/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rckt.h"

@interface rcktCamerasViewController : UIViewController {
    float ratio;
    NSString *URLstream;
}


@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UICollectionView *cams;
@property (strong, nonatomic) IBOutlet UITableView *camsTable;
@property (nonatomic, strong) NSMutableArray *camerasArray;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end
