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
    NSString *sid;
    NSString *sessionID;
    NSString *sessionURL;
    NSString *sessionCam;
    rckt *r;
}

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIWebView *cam;
@property (strong, nonatomic) IBOutlet UICollectionView *cams;
@property (nonatomic, strong) NSMutableArray *camerasArray;

@end
