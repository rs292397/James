//
//  rckt.m
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//



//    _splashTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
//- (void)updateUI: (NSTimer*) timer {

    
#import "rckt.h"

@implementation rckt


- (NSString*)GetServerURL {
    
    //NSString *deviceName = [[UIDevice currentDevice] name];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //return [NSString stringWithFormat:@"%@/James/API/%@/%@",[prefs objectForKey:@"SERVERURL"],[deviceName stringByReplacingOccurrencesOfString:@" " withString:@"_"],[prefs objectForKey:@"DEVICETOKEN"]];
    return [NSString stringWithFormat:@"%@/James/API/td/%@",[prefs objectForKey:@"SERVERURL"],[prefs objectForKey:@"DEVICETOKEN"]];
}


@end
