//
//  rcktAppDelegate.h
//  James
//
//  Created by Modesty & Roland on 22/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface rcktAppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate> {
    BOOL isRunning;
}

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAlertView *uialert;

@end
