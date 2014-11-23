//
//  rcktDoorbellFormSheet.h
//  James
//
//  Created by Modesty & Roland on 23/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

@interface rcktDoorbellFormSheet : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;


-(void)playDoorbellSound;

@end
