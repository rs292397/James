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
#import "rckt.h"

@interface rcktSplashViewController () {
    int count;
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
    [_splashActivityIndicatorView startAnimating];
    _splashActivityIndicatorView.hidesWhenStopped = TRUE;
    
}
- (void)viewDidAppear:(BOOL)animated {
 
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%@", [deviceName stringByReplacingOccurrencesOfString:@" " withString:@"_"]] forKey:@"DEVICEID"];
    [prefs synchronize];

    count = 0;
    
    NSString *urlServer = [[rckt alloc] GetServerURL];
    if ([self validateUrl:urlServer])
        [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlServer]]];
    else
        [self presentForm];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (BOOL) validateUrl: (NSString *) candidate {
    //NSString *urlRegEx =
    //@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    // NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", candidate]];
    return (url!=nil);
    //return [urlTest evaluateWithObject:candidate];
}

- (void) doAPIrequest: (NSURL *)url {
    
    //NSLog(@"%@", url.absoluteString);

    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
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
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
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
    
    
    
    NSString *urlServer = [[rckt alloc] GetServerURL];
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    //NSLog(@"%@",urlConnection);
    //NSLog(@"%@", urlServer);
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
        count += 1;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllAreas",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"AREAS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllLights",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"LIGHTS"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllScenes",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"SCENES"];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllButtons/3", urlServer]]];
        } else if ([urlConnection isEqualToString: [NSString stringWithFormat:@"%@/getAllButtons/3",urlServer]]) {
            [prefs setObject:htmlSTR forKey:@"SCENARIOS"];
        }
        [prefs synchronize];
 
        if (count ==1) {
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StartSplitViewController"];
            rcktAppDelegate *app = (rcktAppDelegate*) [[UIApplication sharedApplication] delegate];
            // UIViewController *currentcontroller = app.window.rootViewController;
            //app.window.rootViewController = controller;
            // app.window.rootViewController = currentcontroller;
            [UIView transitionWithView:self.navigationController.view.window duration:0.5 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{app.window.rootViewController=controller;} completion:nil];
            
        }
    }
    
}

-(void) presentForm {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    rcktDeviceTokenFormsheet *vc = (rcktDeviceTokenFormsheet*)[storyboard instantiateViewControllerWithIdentifier:@"DeviceTokenFormsheet"];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:vc animated:YES completion:nil];
   
}

@end
