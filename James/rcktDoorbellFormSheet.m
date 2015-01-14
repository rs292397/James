//
//  rcktDoorbellFormSheet.m
//  James
//
//  Created by Modesty & Roland on 23/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktDoorbellFormSheet.h"
#import "rckt.h"
#import "CoreGraphics/CoreGraphics.h"

@interface rcktDoorbellFormSheet ()

@end

@implementation rcktDoorbellFormSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    r = [[rckt alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated {
    [self closeCam];
}

- (void) viewDidAppear:(BOOL)animated {
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
    //[self playDoorbellSound];
    [self showCam];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showCam {
    
 //   UIScreen *mainScreen = [UIScreen mainScreen];
 //   [mainScreen setBrightness:0];
    NSString *urlServer = [r GetServerURL];
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
    
}

-(void)closeCam {
    NSString *urlServer = [r GetServerURL];
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/logout/%@", urlServer, sessionID];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
}


- (void)cmdCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playDoorbellSound {
    
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ring2.caf"];
    NSError* error;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    self.player.delegate = self;
    [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        //NSLog(@"audioPlayerDidFinishPlaying successfully");
    }
}

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
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSLog(@"%@", [self.connection.currentRequest.URL absoluteString]);
    //NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlSTR);
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    //NSLog(@"%@", urlConnection );
    NSString *urlServer = [r GetServerURL];
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer]]) {
        NSError* error;
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

        sessionID = json[@"SID"];
        sessionURL = json[@"url"];
        sessionCam = json[@"IDCamDoorbell"];
        
        if (sessionCam.integerValue>0) {
            NSString *str = [NSString stringWithFormat:@"%@/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=%@&format=mjpeg&_sid=%@", sessionURL, sessionCam, sessionID];
            
            /* SHOW IN WEBVIEW */
            NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"100%%\" height=\"100%%\" />", str];
            [self.web loadHTMLString:html baseURL:nil];
        }
        
        
    }
    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/surveillanceStation/logout", urlServer]]) {
        //NSLog(@"Logout: %@", sessionID);
    }
    else {
        //NSLog(@"%@", htmlSTR);
    }
    
}

@end
