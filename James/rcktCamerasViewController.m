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
#import "rcktCameraCollectionViewCell.h"


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
    [self closeCam];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    r = [[rckt alloc] init];
    

    
    NSString *urlServer = [r GetServerURL];
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeCam {
    NSString *urlServer = [r GetServerURL];
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/logout/%@", urlServer, sessionID];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
    NSLog(@"closeCam");
}

- (void)fetchData {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSString *key = [NSString stringWithFormat:@"camera"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"CAMERAS"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _camerasArray = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _camerasArray = [[NSMutableArray alloc] init];
        [_camerasArray addObject:[json objectForKey:key]];
    }
    [self.cams reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
        [self fetchData];
    }
    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/surveillanceStation/logout", urlServer]]) {
        //NSLog(@"Logout: %@", sessionID);
    }
    else {
        //NSLog(@"%@", htmlSTR);
    }
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _camerasArray.count;
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [self.camerasArray objectAtIndex:indexPath.row];

    rcktCameraCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cameraCollectionViewCell" forIndexPath:indexPath];

    cell.key.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    NSString *str = [NSString stringWithFormat:@"%@/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=%@&format=mjpeg&_sid=%@", sessionURL, item[@"ID"], sessionID];
    
    // SHOW IN WEBVIEW
    NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"100%%\" height=\"100%%\" />", str];
    [cell.cam loadHTMLString:html baseURL:nil];

    __weak rcktCameraCollectionViewCell *weakCell=cell;
    
    [cell setDidTapBlock:^(id sender) {
        
        NSDictionary *item = [self.camerasArray objectAtIndex:[weakCell.lbl.text integerValue]];

        NSString *str = [NSString stringWithFormat:@"%@/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=%@&format=mjpeg&_sid=%@", sessionURL, item[@"ID"], sessionID];
        // SHOW IN WEBVIEW
        float ratio = [item[@"resolutionWidth"] floatValue] / [item[@"resolutionHeight"] floatValue];
        NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"%fpx\" height=\"%fpx\" />", str, _cam.frame.size.width, _cam.frame.size.width*ratio];
        
        NSLog(@"%fx%f", _cam.frame.size.width, _cam.frame.size.height);
        UINavigationItem *navitm = [self navigationItem];
            navitm.title = [NSString stringWithFormat:@"%@", item[@"description"]];
        [_cam setFrame:CGRectMake(_cam.frame.origin.x, 8, _cam.frame.size.width, _cam.frame.size.width)];
        NSLog(@"%fx%f", _cam.frame.size.width, _cam.frame.size.height);
        [_cam loadHTMLString:html baseURL:nil];
    }];
    return cell;
}



@end
