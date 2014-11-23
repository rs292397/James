//
//  rcktCamerasViewController.m
//  James
//
//  Created by Modesty & Roland on 09/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktCamerasViewController.h"
#import "rckt.h"
#import "CoreGraphics/CoreGraphics.h"


@interface rcktCamerasViewController ()  

@end


@implementation rcktCamerasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewDidDisappear:(BOOL)animated {
    [self btnLogoutClick:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    /* UIImageView
    endMarkerData=nil;
    if (endMarkerData == nil) {
        uint8_t endMarker[2] = {0xFF, 0xD9};
        endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
    }
    */
    //[self btnLoginClick:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)btnLoginClick:(id)sender {

    UIScreen *mainScreen = [UIScreen mainScreen];
    [mainScreen setBrightness:0];
    
    NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/auth.cgi"];
    //NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/auth.cgi?api=SYNO.API.Auth&method=Login&version=2&account=roland&passwd=levi&session=SurveillanceStation"];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
//    NSString *urlServer = [[rckt alloc] GetServerURL];
    
}


-(IBAction)btnStreamClick:(id)sender {

    NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=1&format=mjpeg&_sid=%@",sid];
    
    /* SHOW IN WEBVIEW */
    NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"100%%\" height=\"100%%\" />", str];
    [self.web loadHTMLString:html baseURL:nil];

    /* UIImageView
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
    */
}

-(IBAction)btnCloseStreamClick:(id)sender {
    //[self.connection cancel];
    NSLog(@"cam selected");
}

-(IBAction)btnLogoutClick:(id)sender {
    NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/auth.cgi?api=SYNO.API.Auth&method=Logout&version=2&session=SurveillanceStation"];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
}

- (void) doAPIrequest: (NSURL *)url {
    NSLog(@"%@", url.absoluteString);
    
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
    
    /* UIImageview
    
     NSRange endRange = [self.receivedData rangeOfData: endMarkerData options:0 range:NSMakeRange(0,self.receivedData.length)];
    NSInteger endLocation = endRange.location + endRange.length;
    if (self.receivedData.length>=endLocation) {
        NSData *imageData = [self.receivedData subdataWithRange:NSMakeRange(0,endLocation)];
        UIImage *receivedImage = [UIImage imageWithData:imageData];
        if (receivedImage) {
            self.img.image = receivedImage;
        }
    }
    */
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
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/auth.cgi?api=SYNO.API.Auth&method=Login"]]) {
        NSError* error;
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSDictionary *data = [json objectForKey:@"data"];
        sid = [data objectForKey:@"sid"];
        //NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/SurveillanceStation/camera.cgi?api=SYNO.SurveillanceStation.Camera&method=List&version=2&_sid=%@",sid];
        //[self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
        [self btnStreamClick:nil];
    }
    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/SurveillanceStation/camera.cgi"]]) {
        NSLog(@"%@", htmlSTR);
    }
    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/SurveillanceStation/videoStreaming.cgi"]]) {
        
        NSLog(@"%@", htmlSTR);
        
        
    }
    else {
        NSLog(@"%@", htmlSTR);
        
    }
    

    

}



@end
