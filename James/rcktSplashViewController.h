//
//  rcktSplashViewController.h
//  James
//
//  Created by Modesty & Roland on 29/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rckt.h"

@interface rcktSplashViewController : UIViewController {
    rckt *r;
    
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* splashActivityIndicatorView;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

-(void)initialize;

@end
