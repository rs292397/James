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
    countToDo = 6;
    [self performSelectorOnMainThread:@selector(animateProgressBar) withObject:nil waitUntilDone:NO];
}

- (void)animateProgressBar {
    
    if (count < countToDo) {
        float progress = (float)count/(float)countToDo;
        _progressView.progress = (float) progress;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateProgressBar) userInfo:nil repeats:NO];
        
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
    [prefs setObject:[NSString stringWithFormat:@"%@", [deviceName stringByReplacingOccurrencesOfString:@" " withString:@"_"]] forKey:@"DEVICEID"];
    [prefs synchronize];
    
    count = 0;
    
    r = [[rckt alloc] init];
    NSString *urlServer = [r GetServerURL];
//    NSString *postData = [NSString stringWithFormat:@"{\"deviceToken\":\"%@\", \"notifyDoorbell\":\"%hhd\"}", [prefs objectForKey:@"NOTIFICATION_TOKEN"], [prefs boolForKey:@"NOTIFICATION_DOORBELL"]];
    NSString *postData = [NSString stringWithFormat:@"{\"iosToken\":\"%@\", \"iosNotifyDoorbell\":\"%hhd\"}", [prefs objectForKey:@"NOTIFICATION_TOKEN"],YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlServer]];
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
    NSString *urlServer = [[rckt alloc] GetServerURL];
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    //NSLog(@"%@",urlConnection);
    //NSLog(@"%@", urlServer);
    count += 1;

    if ([urlServer isEqualToString:urlConnection]) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        NSString *keyCode = [json valueForKey:@"code"];
        if (keyCode!=nil) {
            NSInteger code = [keyCode integerValue];
            if (code<0) {
                [self presentForm];
                NSLog(@"fout");
            } else {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[NSString stringWithFormat:@"%@", [json valueForKey:@"message"]] forKey:@"DEVICETOKEN"];
                [prefs synchronize];
                NSLog(@"%@",htmlSTR);
                
                NSString *urlServer = [[rckt alloc] GetServerURL];
                //Get All Objects
                [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllAreas", urlServer]]];

            }
        } else {
            [self presentForm];
            NSLog(@"Wrong URL");
        }
    } else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllAreas",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"AREAS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllLights",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"LIGHTS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllShades", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllShades",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"SHADES"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllScenes",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"SCENES"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllButtons/3", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllButtons/3",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"SCENARIOS"];
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
