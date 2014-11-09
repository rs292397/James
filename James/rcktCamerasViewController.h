//
//  rcktCamerasViewController.h
//  James
//
//  Created by Modesty & Roland on 09/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktCamerasViewController : UIViewController {
    NSString *sid;
    /*UIImageView
     NSData *endMarkerData;
     */
}

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnStream;
@property (strong, nonatomic) IBOutlet UIButton *btnCloseStream;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIWebView *web;
@property (strong, nonatomic) IBOutlet UIImageView *img;

-(IBAction)btnLoginClick:(id)sender;
-(IBAction)btnStreamClick:(id)sender;
-(IBAction)btnCloseStreamClick:(id)sender;
-(IBAction)btnLogoutClick:(id)sender;
@end
