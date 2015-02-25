//
//  rcktSplashViewController.m
//  James
//
//  Created by Modesty & Roland on 29/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSplashViewController.h"
#import "rcktAppDelegate.h"
#import "rcktDeviceTokenFormsheet.h"
#import "rcktRootTableViewController.h"
#import "rckt.h"

@interface rcktSplashViewController () {
    int count;
    int countToDo;
}

@end

@implementation rcktSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //   [_splashActivityIndicatorView startAnimating];
    //_splashActivityIndicatorView.hidesWhenStopped = TRUE;
    _progressView.progress = 0.0f;
    countToDo = 8;
    [self performSelectorOnMainThread:@selector(animateProgressBar) withObject:nil waitUntilDone:NO];
}

- (void)animateProgressBar {
    
    if (count < countToDo) {
        float progress = (float)count/(float)countToDo;
        _progressView.progress = (float) progress;
//        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateProgressBar) userInfo:nil repeats:NO];
        
    }
    else {
        
    }
  
}

- (void)viewDidAppear:(BOOL)animated {


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize {
    //initialize new mutable data
    NSLog(@"Initialize James...");
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    //Create userdefaults if not exist
    if ([prefs objectForKey:@"PASSWORD"]==nil)
        [prefs setObject:@"myPassword" forKey:@"PASSWORD"];

    if ([prefs objectForKey:@"NOTIFY_DOORBELL"]==nil)
        [prefs setBool:NO forKey:@"NOTIFY_DOORBELL"];
    if ([prefs objectForKey:@"NOTIFICATION_TOKEN"]==nil)
        [prefs setObject:@"" forKey:@"NOTIFACTION_TOKEN"];
    if ([prefs objectForKey:@"AREAS"]==nil)
        [prefs setObject:@"" forKey:@"AREAS"];
    if ([prefs objectForKey:@"LIGHTS"]==nil)
        [prefs setObject:@"" forKey:@"LIGHTS"];
    if ([prefs objectForKey:@"SHADES"]==nil)
        [prefs setObject:@"" forKey:@"SHADES"];
    if ([prefs objectForKey:@"SCENES"]==nil)
        [prefs setObject:@"" forKey:@"SCENES"];
    if ([prefs objectForKey:@"SCENARIOS"]==nil)
        [prefs setObject:@"" forKey:@"SCENARIOS"];
    if ([prefs objectForKey:@"FRONTDOOR"]==nil)
        [prefs setObject:@"" forKey:@"FRONTDOOR"];
    if ([prefs objectForKey:@"CAMERAS"]==nil)
        [prefs setObject:@"" forKey:@"CAMERAS"];
    if ([prefs objectForKey:@"CAM_SID"]==nil)
        [prefs setObject:@"" forKey:@"CAM_SID"];
    if ([prefs objectForKey:@"CAM_URL"]==nil)
        [prefs setObject:@"" forKey:@"CAM_URL"];

    [prefs setObject:[NSString stringWithFormat:@"%@", [deviceName stringByReplacingOccurrencesOfString:@" " withString:@"_"]] forKey:@"DEVICEID"];
    [prefs synchronize];
    
    count = 0;
    r = [[rckt alloc] init];
    NSString *postData = [NSString stringWithFormat:@"{\"iosToken\":\"%@\", \"iosNotifyDoorbell\":%s}", [prefs objectForKey:@"NOTIFICATION_TOKEN"],[prefs boolForKey:@"NOTIFY_DOORBELL"]? "true" : "false"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [r GetServerURL]]];
    if (url != nil)
        [self doAPIrequestPUT:url postData:postData];
    else
        [self presentForm];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) doAPIrequest: (NSURL *)url {
    
    //NSLog(@"%@", url.absoluteString);

    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}

- (void) doAPIrequestPUT: (NSURL*) url postData:(NSString*) postData{
    
    //NSLog(@"%@", url.absoluteString);
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //set http method
    [request setHTTPMethod:@"PUT"];
    //initialize a post data
    //NSString *postData = [NSString stringWithFormat:@"j_username=role&j_password=tomcat"];
    //set request content type we MUST set this value.
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self presentForm];
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    //NSLog(@"%@", [self.connection.currentRequest.URL absoluteString]);
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    
    
    //NSLog(@"%@", htmlSTR);
    //NSString *urlServer = [[rckt alloc] GetServerURL];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    //NSLog(@"%@",urlConnection);
    //NSLog(@"%@", urlServer);
    count += 1;
    [self performSelectorOnMainThread:@selector(animateProgressBar) withObject:nil waitUntilDone:NO];

    if (count==1) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        NSString *keyCode = [json valueForKey:@"code"];
        if (keyCode!=nil) {
            NSInteger code = [keyCode integerValue];
            if (code<0) {
                [self presentForm];
                NSLog(@"fout");
            } else {
                NSLog(@"%@",htmlSTR);
                [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllAreas", [r GetServerURL]]]];
            }
        } else {
            [self presentForm];
            NSLog(@"Wrong URL");
        }
    } else {
        if ([urlConnection containsString:@"getAllAreas"]) {
            [prefs setObject:htmlSTR forKey:@"AREAS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getAllLights"]) {
            [prefs setObject:htmlSTR forKey:@"LIGHTS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllShades", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getAllShades"]) {
            [prefs setObject:htmlSTR forKey:@"SHADES"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getAllScenes"]) {
            [prefs setObject:htmlSTR forKey:@"SCENES"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllButtons/3", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getAllButtons/3"]) {
            [prefs setObject:htmlSTR forKey:@"SCENARIOS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getFrontDoor", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getFrontDoor"]) {
            [prefs setObject:htmlSTR forKey:@"FRONTDOOR"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllCameras", [r GetServerURL]]]];
        } else if ([urlConnection containsString:@"getAllCameras"]) {
            [prefs setObject:htmlSTR forKey:@"CAMERAS"];
        }
        [prefs synchronize];

        
        
        if (count == countToDo) {
            NSLog(@"Done initializing");
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StartSplitViewController"];
                rcktAppDelegate *app = (rcktAppDelegate*) [[UIApplication sharedApplication] delegate];
                // UIViewController *currentcontroller = app.window.rootViewController;
                //app.window.rootViewController = controller;
                // app.window.rootViewController = currentcontroller;
                [UIView transitionWithView:self.navigationController.view.window duration:0.5 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{app.window.rootViewController=controller;} completion:nil];
            }
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                UINavigationController *vc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"ROOT_NAVIGATION"];
                [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:vc animated:YES completion:nil];
                
            }
 
        }
    }
    
}

-(void) presentForm {
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    rcktDeviceTokenFormsheet *vc = (rcktDeviceTokenFormsheet*)[storyboard instantiateViewControllerWithIdentifier:@"DeviceTokenFormsheet"];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:vc animated:YES completion:nil];
   
}

@end
