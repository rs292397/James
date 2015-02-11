//
//  rcktCameraFormSheet.h
//  James
//
//  Created by Modesty en Roland on 05/02/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktCameraFormSheet : UIViewController {
    float ratio;
    NSString *URLstream;
    bool doStream;
    BOOL showNavBar;
}


@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;



-(void)setStreamValues: (NSString*)url ratio:(float)r;
-(void)setImageValues: (UIImage*)img ratio:(float)r;

-(IBAction)close:(id)sender;

@end
