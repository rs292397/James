//
//  rcktAppDelegate.m
//  James
//
//  Created by Modesty & Roland on 22/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktAppDelegate.h"
#import "rcktDoorbellFormSheet.h"
#import "GCDAsyncUdpSocket.h"
#import "rckt.h"

@implementation rcktAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
//    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    [application setMinimumBackgroundFetchInterval:40000];
    
    
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSLog(@"udp allocated");
    [self startStop];


    return YES;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    //if (self.window.rootViewController) {
    //    UIViewController* presented = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
    //    orientations = [presented supportedInterfaceOrientations]
    //}
    return orientations;
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"Start urlsessionrequest");
    [self URLrequest];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    //NSURLSessionDownloadTask *task = [[self backgroundURLSession] downloadTaskWithRequest:request];
    //task.taskDescription = [NSString stringWithFormat:@"test"];
    //[task resume];
    
   // self.backgroundTransferCompletionHandler = completionHandler;
    //self.backgroundTransferCompletionHandler(UIBackgroundFetchResultNewData);
    
    //[self notificationDoorbell:application];
    //[self showDoorbellFormsheet:application];
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    self.backgroundTransferCompletionHandler = completionHandler;
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self showDoorbellFormsheet:application];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)URLrequest {
    NSString *urlServer = [[rckt alloc] GetServerURL];
    NSString *downloadURLString = [NSString stringWithFormat:@"%@/getAllAreas", urlServer];
    NSURL* downloadURL = [NSURL URLWithString:downloadURLString];
    
    NSString *idf = [NSString stringWithFormat:@"%@", [NSDate date]];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:idf];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    [[self.session downloadTaskWithURL:downloadURL] resume];

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{


    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[location path]]) {
        NSLog(@"%@", [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:&error]);
        if (error)
            NSLog(@"%@", error);
        [fileManager removeItemAtURL:location error:nil];
    }
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(URLrequest)
                                   userInfo:nil
                                    repeats:NO];
    
//    [self URLrequest];

    // The main act...
    //NSLog(@"%@",[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding]);

    
}

/*
- (void)         URLSession:(NSURLSession *)session
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
  didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"downloadTask:%@ didFinishDownloadingToURL:%@", downloadTask.taskDescription, location);
    
    // Copy file to your app's storage with NSFileManager
    // ...
    
    // Notify your UI
}

- (void)  URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
   didResumeAtOffset:(int64_t)fileOffset
  expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)         URLSession:(NSURLSession *)session
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
               didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
  totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}
*/


-(void) application:(UIApplication *)application performFetchWithCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Background fetch started...");
    
    //---do background fetch here---
    // You have up to 30 seconds to perform the fetch
    
    
    NSLog(@"Background fetch completed...");
}


-(void)notificationDoorbell: (UIApplication*) application {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *dateTime = [NSDate date];
    localNotification.fireDate = dateTime;
    localNotification.alertBody = [NSString stringWithFormat:@"Somebody is at the front door %@", dateTime];
    //localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.soundName = @"ring2.caf";
    localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber + 1;
    [application scheduleLocalNotification:localNotification];
}

-(void)showDoorbellFormsheet: (UIApplication *)application {
    
    if ([[application keyWindow].rootViewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController*)[application keyWindow].rootViewController;
        UIViewController *pvc = svc.presentedViewController;
        
        if ([pvc isKindOfClass:[rcktDoorbellFormSheet class]]) {
            rcktDoorbellFormSheet *fs = (rcktDoorbellFormSheet*) pvc;
            [fs playDoorbellSound];
            
        }
        else {
            UIViewController *vc = svc.viewControllers[1];
            UIStoryboard *storyboard;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            
            rcktDoorbellFormSheet *fs = (rcktDoorbellFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"DoorbellFormsheet"];
            [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [vc presentViewController:fs animated:YES completion:nil];
        }

    }
}

- (void)startStop
{
    if (isRunning)
    {
        // STOP udp echo server
        
        [_udpSocket close];
        
        NSLog(@"Stopped Udp Echo server");
        isRunning = false;
        
    }
    else
    {
        // START udp echo server
        
        int port = 23;
        if (port < 0 || port > 65535)
        {
            port = 0;
        }
        
        NSError *error = nil;
        
        if (![_udpSocket bindToPort:port error:&error])
        {
            NSLog(@"Error starting server (bind): %@", error);
            return;
        }
        
        if (![_udpSocket beginReceiving:&error])
            
        {
            [_udpSocket close];
            
            NSLog(@"Error starting server (recv): %@", error);
            return;
        }
        
        NSLog(@"Udp Echo server started on port %hu", [_udpSocket localPort]);
        isRunning = YES;
        
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if (!isRunning) return;
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        /* If you want to get a display friendly version of the IPv4 or IPv6 address, you could do this:
         
         NSString *host = nil;
         uint16_t port = 0;
         [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
         
         */
        
        NSLog(@"%@",msg);
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    
    [_udpSocket sendData:data toAddress:address withTimeout:-1 tag:0];
}


@end
