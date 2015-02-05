//
//  rcktDoorbellFormSheet.h
//  James
//
//  Created by Modesty & Roland on 23/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "rckt.h"

@interface rcktDoorbellFormSheet : UIViewController <AVAudioPlayerDelegate> {
    float ratio;
}

@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


-(void)playDoorbellSound:(NSString*)sound;

@end
