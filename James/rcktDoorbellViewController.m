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
#import "rcktDoorbellImageFormSheet.h"

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

    UINavigationItem *navitm = self.navbaritem;
    navitm.title = [NSString stringWithFormat:@"Doorbell Messages"];
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Live Cam" style:UIBarButtonItemStyleDone target:self action:@selector(cmdLiveCam)];
    navitm.rightBarButtonItem = br;
    
    //Login to surveillancestation and activate stream in webview
    //NSString *str = [NSString stringWithFormat:@"%@/surveillanceStation/login", urlServer];
    NSString *str = [NSString stringWithFormat:@"%@/getMessagesByType/1", urlServer];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]];
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

-(void)cmdLiveCam {
    [[[rckt alloc] init] showDoorbellFormsheet:NO sound:@""];
}

-(void)fetchMessages:(NSDictionary*) data {
    NSString *key = [NSString stringWithFormat:@"message"];
    id itm = [data valueForKey:key];

    _messagesArray = [[NSMutableArray alloc] init];
    if ([itm isKindOfClass:[NSMutableArray class]]) {
        for (NSDictionary *itm in [data objectForKey:key])
            [_messagesArray addObject:itm];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        [_messagesArray addObject:[data objectForKey:key]];
    }
    [self.messagesTableView reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self tableView:self.messagesTableView didSelectRowAtIndexPath:index];
    
}

-(IBAction)switchNtoficationChange:(id)sender {
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

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Item
    NSDictionary *item = [self.messagesArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"messageTableViewCell";
    rcktMessageTableViewCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Amsterdam"]];
    NSDate *dte = [dateFormat dateFromString:[NSString stringWithFormat:@"%@", item[@"dateTime"]]];
    [dateFormat setDateFormat:@"EEEE"];
    cell.lblDay.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:dte]];
    [dateFormat setDateFormat:@"dd MMMM YYYY"];
    cell.lblDate.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:dte]];
    [dateFormat setDateFormat:@"HH:mm"];
    cell.lblTime.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:dte]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }

    

    return cell;
}
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
 }
 */

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
            
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.class == [rcktMessageTableViewCell class]) {
            [tableView beginUpdates];
            NSArray *indexPaths = @[indexPath];
            [self.messagesArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            NSString *key = [NSString stringWithFormat:@"%@",((rcktMessageTableViewCell*)cell).key.text];
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/deleteObject/message/%@", urlServer,key]]];
                
                
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        /*
        NSLog(@"%@", htmlSTR);
        NSError* error;
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSString *sessionID = json[@"SID"];
        NSString *sessionURL = json[@"url"];
        NSString *sessionCam = json[@"IDCamDoorbell"];
        NSString *str = [NSString stringWithFormat:@"%@/webapi/SurveillanceStation/videoStreaming.cgi?api=SYNO.SurveillanceStation.VideoStream&method=Stream&version=1&cameraId=%@&format=mjpeg&_sid=%@", sessionURL, sessionCam, sessionID];
        // SHOW IN WEBVIEW
        NSString *html = [NSString stringWithFormat:@"<img name=\"cam\" src=\"%@\" width=\"100%%\" height=\"100%%\" />", str];
        [self.live loadHTMLString:html baseURL:nil];
        */
    }

    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getMessagesByType", urlServer]]) {
        //NSLog(@"%@", htmlSTR);
        NSError* error;
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        [self fetchMessages:json];
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
        if (img) {
            //float ratio =  img.size.height/img.size.width;
            //[_img setFrame:CGRectMake(0, 0, 10, 10)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [_img setImage:img];
            }
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                rcktDoorbellImageFormSheet *vc = (rcktDoorbellImageFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"DoorbellImageFormSheet"];
                [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [vc setImage:img];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }

    }
    else {
        //NSLog(@"%@", htmlSTR);
        
    }
    
    
    
    
}


@end
