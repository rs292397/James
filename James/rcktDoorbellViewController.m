//
//  rcktDoorbellViewController.m
//  James
//
//  Created by Modesty & Roland on 13/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktDoorbellViewController.h"
#import "rckt.h"
#import "rcktMessageTableViewCell.h"

@interface rcktDoorbellViewController ()

@end

@implementation rcktDoorbellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    urlServer = [[[rckt alloc] init] GetServerURL];

    //Login to surveillancestation and activate stream in webview
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer];
    NSLog(@"%@", str);
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated {
    NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/logout", urlServer];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)btnLiveViewClick:(id)sender {
    NSString *str = [NSString stringWithFormat:@"http://192.168.1.90:5000/webapi/auth.cgi?api=SYNO.API.Auth&method=Logout&version=2&session=SurveillanceStation"];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _messagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Item
    NSDictionary *item = [self.messagesArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"messageTableViewCell";
    rcktMessageTableViewCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
//    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
//    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
//    cell.img.image = [UIImage imageNamed:@"scenario_icon.png"];
//    if ([item[@"state"] isEqualToString:@"true"])
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    else
//        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
 }
 */
#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *itm = [self.messagesArray objectAtIndex:indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@/getMessageImage/%@", urlServer, itm[@"ID"]];
    [self doAPIrequest:[NSURL URLWithString:url]];

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
    
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer]]) {
        NSLog(@"%@", htmlSTR);
        NSError* error;
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSString *sessionID = json[@"SID"];
        NSString *sessionURL = json[@"url"];
        NSString *sessionCam = json[@"IDCamDoorbell"];
        NSString *str = [NSString stringWithFormat:@"%@/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=%@&format=mjpeg&_sid=%@", sessionURL, sessionCam, sessionID];
        /* SHOW IN WEBVIEW */
        NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"100%%\" height=\"100%%\" />", str];
        [self.live loadHTMLString:html baseURL:nil];
    }

    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getMessagesByType", urlServer]]) {
        NSLog(@"%@", htmlSTR);
    }

    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getMessageImage", urlServer]]) {
        
//        NSError* error;
//        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//        NSString *imgS = json[@"img"];
        
//        NSData* imageData = [[NSData alloc] initWithBase64EncodedString:imgS options:0];
        //NSData *x = [[NSData alloc] initWithBase64EncodedString:htmlSTR options:0];
//        UIImage *img = [[UIImage alloc] initWithData:imageData];
        UIImage *img = [[UIImage alloc] initWithData:self.receivedData];
        if (img)
            [_img setImage:img];
    }
    else {
        //NSLog(@"%@", htmlSTR);
        
    }
    
    
    
    
}


@end
