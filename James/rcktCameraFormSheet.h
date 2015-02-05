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
}


@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

-(void)setStreamValues: (NSString*)url ratio:(float)r;
-(IBAction)close:(id)sender;

@end
