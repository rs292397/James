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
#import "rcktCameraFormSheet.h" 

@interface rcktDoorbellFormSheet ()

@end

@implementation rcktDoorbellFormSheet

#define END_MARKER_BYTES { 0xFF, 0xD9 }
static NSData *_endMarkerData = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator = [[rckt alloc] getActivityIndicator:_image];
    [_image addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //UIImageView
    if (_endMarkerData == nil) {
        uint8_t endMarker[2] = END_MARKER_BYTES;
        _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
    }
    
    NSError *error;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"FRONTDOOR"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:@"cam"];
    if ([itm isKindOfClass:[NSDictionary class]]) {
        NSDictionary *cam = [json objectForKey:@"cam"];
        URLstream = [NSString stringWithFormat:@"%@",cam[@"URLstream"]];
        //str = [NSString stringWithFormat:@"%@/getCameraStream/5",[[rckt alloc] GetServerURL]];
        ratio = [[cam objectForKey:@"resolutionHeight"] floatValue] / [[cam objectForKey:@"resolutionWidth"] floatValue];
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

- (void) viewDidAppear:(BOOL)animated {
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
    //[self playDoorbellSound];
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

- (void)playDoorbellSound: (NSString*) sound {
    
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sound];
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
    
    if (self.activityIndicator.isAnimating)
        [self.activityIndicator stopAnimating];
    
    [self.receivedData appendData:data];
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(0, _receivedData.length)];
    
    long endLocation = endRange.location + endRange.length;
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [_image setFrame: CGRectMake(_image.frame.origin.x, _image.frame.origin.y, _image.frame.size.width, _image.frame.size.width * ratio)];
    else {
        float height = _image.frame.size.width * ratio;
        [_image setFrame: CGRectMake(0, ((self.view.frame.size.height-height)/2)+20, _image.frame.size.width, height)];
    }
    
    [_image setImage:_img];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] == _image) {
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            rcktCameraFormSheet *vc = (rcktCameraFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"CameraFormSheet"];
            [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [vc setStreamValues:URLstream ratio:ratio];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}


@end
