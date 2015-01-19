//
//  rcktAppDelegate.m
//  James
//
//  Created by Modesty & Roland on 22/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktAppDelegate.h"
#import "rckt.h"
#import "rcktDoorbellFormSheet.h"
#import "rcktSplashViewController.h"


@implementation rcktAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
        NSLog(@"Remote notifications registration request...");
    }

    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
//    [[MyModel sharedModel] setApnsToken:];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%@", hexToken] forKey:@"NOTIFICATION_TOKEN"];
    [prefs synchronize];

    NSLog(@"Remote notification registered succesfully: %@", hexToken);
    UIViewController *vc = self.window.rootViewController;
    if ([vc isKindOfClass:[rcktSplashViewController class]]) {
        [(rcktSplashViewController*) vc initialize];
    }
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote notification registration failed! Error: %@", error);
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    //if (self.window.rootViewController) {
    //    UIViewController* presented = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
    //    orientations = [presented supportedInterfaceOrientations]
    //}
    return orientations;
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([userInfo objectForKey:@"category"]) {
        if ([[userInfo objectForKey:@"category"] isEqualToString:@"Doorbell"]) {
            rckt *r = [[rckt alloc] init];
            [r showDoorbellFormsheet: (application.applicationState == UIApplicationStateActive)];
        }
    }
    
//    NSString *badge = @"";
//    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//    if( [apsInfo objectForKey:@"badge"] != NULL)
//    {
//        badge = [apsInfo objectForKey:@"badge"];
//    }

    /*
    if ( application.applicationState == UIApplicationStateActive)
    {
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        
        NSString *alertMsg = @"";
        NSString *badge = @"";
        NSString *sound = @"";
        NSString *custom = @"";
        NSString *x;
        
        if( [userInfo objectForKey:@"acme2"] != NULL)
        {
            x = [userInfo objectForKey:@"acme2"];
        }
        
        if( [apsInfo objectForKey:@"alert"] != NULL)
        {
            alertMsg = [apsInfo objectForKey:@"alert"];
        }
        
        
     
        
        if( [apsInfo objectForKey:@"sound"] != NULL)
        {
            sound = [apsInfo objectForKey:@"sound"];
        }
        
        if( [userInfo objectForKey:@"Type"] != NULL)
        {
            custom = [userInfo objectForKey:@"Type"];
        }

        NSLog(@"%@", custom);
        NSLog(@"%@", alertMsg);
    }
     */
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
    
    
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self showDoorbellFormsheet:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)notificationDoorbell: (UIApplication*) application {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *dateTime = [NSDate date];
    localNotification.fireDate = dateTime;
    localNotification.alertBody = [NSString stringWithFormat:@"Somebody is at the front door %@", dateTime];
    //localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.soundName = @"ring2.caf";
    //localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber + 1;
    [application scheduleLocalNotification:localNotification];
}




@end
