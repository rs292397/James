//
//  rcktCameraFormSheet.m
//  James
//
//  Created by Modesty en Roland on 05/02/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktCameraFormSheet.h"
#import "rckt.h"

@interface rcktCameraFormSheet ()

@end

@implementation rcktCameraFormSheet

#define END_MARKER_BYTES { 0xFF, 0xD9 }
static NSData *_endMarkerData = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator = [[rckt alloc] getActivityIndicator:_image];
    [_image addSubview:self.activityIndicator];
    
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //UIImageView
    if (_endMarkerData == nil) {
        uint8_t endMarker[2] = END_MARKER_BYTES;
        _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
    }

    [self doAPIrequest:[NSURL URLWithString:URLstream]];
    [self addImageToView];
}

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

-(void)viewDidLayoutSubviews{
    [self addImageToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated {
    [self closeCam];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)closeCam {
    [_connection cancel];
}


- (void)cmdCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (self.activityIndicator.isAnimating)
        [self.activityIndicator stopAnimating];
    
    [self.receivedData appendData:data];
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(0, _receivedData.length)];
    
    int endLocation = endRange.location + endRange.length;
    if (_receivedData.length >= endLocation) {
        NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(0, endLocation)];
        UIImage *receivedImage = [UIImage imageWithData:imageData];
        if (receivedImage) {
            _img = receivedImage;
            [self.image setImage:_img];
        }
    }
    
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
    
    
}
-(void)addImageToView {
    float height = _image.frame.size.width * ratio;
    [_image setFrame: CGRectMake(0, (self.view.frame.size.height-height)/2, _image.frame.size.width, height)];
    [_image setImage:_img];
}

-(void)setStreamValues: (NSString*)url ratio:(float)r {
    URLstream = url;
    ratio = r;
}

-(IBAction)close:(id)sender{
    [self cmdCancel];
}

@end
