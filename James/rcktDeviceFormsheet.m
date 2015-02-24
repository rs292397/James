//
//  rcktDeviceFormsheet.m
//  James
//
//  Created by Modesty & Roland on 25/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktDeviceFormsheet.h"
#import "rcktStringTableViewCell.h"
#import "rckt.h"
#import "rcktSettingsDevicesViewController.h"

@interface rcktDeviceFormsheet ()

@end

@implementation rcktDeviceFormsheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    settings = @{@"A" : @[
                         @[@"KEY", @"Identifier", @"1"],
                         @[@"NAME", @"Name", @"James iPad"],
                         @[@"PWD", @"Password", @"0123456789abcdef"]
                         ],
                 @"Z" : @[
                         @[@"DELETE", @"Delete Device", @"Delete Device"]
                         ]
                 };
    settingSectionTitles = [[settings allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    UINavigationItem *navitm = self.navbaritem;
    navitm.title = [NSString stringWithFormat:@"Device"];
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(cmdSaveScene)];
    navitm.rightBarButtonItem = br;

    
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

- (void)setParams:(NSString *)dKey dName:(NSString *) dName dToken:(NSString *) dToken {
    key = dKey;
    name = dName;
    token = dToken;
}

- (void)cmdSaveScene {
    
    NSArray *cells = [self.valuesTableView visibleCells];
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[rcktStringTableViewCell class]]) {
            rcktStringTableViewCell *rcktCell = (rcktStringTableViewCell*) cell;
            if ([rcktCell.key.text isEqualToString:@"KEY"])
                key = [NSString stringWithFormat:@"%@", rcktCell.txt.text];
            else if ([rcktCell.key.text isEqualToString:@"NAME"])
                name = [NSString stringWithFormat:@"%@", rcktCell.txt.text];
            else if ([rcktCell.key.text isEqualToString:@"PWD"])
                token = [NSString stringWithFormat:@"%@", rcktCell.txt.text];
            
        }
    }
    NSString *postData = [NSString stringWithFormat:@"{\"name\":\"%@\", \"pwd\":\"%@\"}", name, token];
    NSString *url = [NSString stringWithFormat:@"%@/saveObject/device/%@", [[rckt alloc] GetServerURL] , key];
    //NSLog(@"%@", postData);
    //NSLog(@"%@", url);
    [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
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

- (void) doAPIrequestPUT: (NSURL*) url postData:(NSString*) postData{
    
    //NSLog(@"%@", url.absoluteString);
    //NSLog(@"%@", postData);
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //set http method
    [request setHTTPMethod:@"PUT"];
    //initialize a post data
    //NSString *postData = [NSString stringWithFormat:@"j_username=role&j_password=tomcat"];
    //set request content type we MUST set this value.
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([key isEqualToString:@"0"])
        return 1;
    else
        return [settingSectionTitles count];
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [settingSectionTitles objectAtIndex:section];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [settingSectionTitles objectAtIndex:section];
    NSArray *sectionSettings = [settings objectForKey:sectionTitle];
    return [sectionSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        static NSString *CellIdentifier = @"commandTableViewCell";
        UITableViewCell *cell = [tableView
                                         dequeueReusableCellWithIdentifier:CellIdentifier
                                         forIndexPath:indexPath];
        return cell;
        
    }
    else {
        static NSString *CellIdentifier = @"stringTableViewCell";
        rcktStringTableViewCell *cell = [tableView
                                         dequeueReusableCellWithIdentifier:CellIdentifier
                                         forIndexPath:indexPath];
        NSString *sectionTitle = [settingSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionSettings = [settings objectForKey:sectionTitle];
        NSArray *sectionSetting = [sectionSettings objectAtIndex:indexPath.row];
        
        cell.key.text = [sectionSetting objectAtIndex:0];
        cell.lbl.text = [sectionSetting objectAtIndex:1];
        if ([key isEqualToString:@"0"]) {
            cell.txt.placeholder = [sectionSetting objectAtIndex:2];
        }
        else {
            if ([[sectionSetting objectAtIndex:0] isEqualToString:@"KEY"])
                cell.txt.text = key;
            else if ([[sectionSetting objectAtIndex:0] isEqualToString:@"NAME"])
                cell.txt.text = name;
            else if ([[sectionSetting objectAtIndex:0] isEqualToString:@"PWD"])
                cell.txt.text = token;
        }
        return cell;
        
    }
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Device" message:@"Deleting this device will disable the device from controlling your home." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex==0) {
        [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/deleteObject/device/%@", [[rckt alloc] GetServerURL],key]]];
    }
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
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlSTR);
   
    rcktSettingsDevicesViewController *vc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *svc = (UISplitViewController*)[self presentingViewController];
        UINavigationController *nav = [svc.viewControllers objectAtIndex:1];
        vc = (rcktSettingsDevicesViewController*)nav.topViewController;
    }
    else {
        UINavigationController *nav = (UINavigationController*) self.presentingViewController;
        if ([[nav.childViewControllers objectAtIndex:2] isKindOfClass:[rcktSettingsDevicesViewController class]])
            vc = (rcktSettingsDevicesViewController*)[nav.childViewControllers objectAtIndex:2];
    }
    [vc didEditObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
