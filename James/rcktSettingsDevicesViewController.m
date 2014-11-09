//
//  rcktSettingsDevicesViewController.m
//  James
//
//  Created by Modesty & Roland on 26/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSettingsDevicesViewController.h"
#import "rckt.h"
#import "rcktLabelTableViewCell.h"
#import "rcktDeviceFormsheet.h"

@interface rcktSettingsDevicesViewController ()

@end

@implementation rcktSettingsDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationItem].title = @"Devices";
    urlServer = [[rckt alloc] GetServerURL];
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //Refresh control tableview
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.devicesTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllDevices", urlServer]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable
{
    //TODO
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllDevices", urlServer]]];
}

- (void)didEditObject {
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllDevices", urlServer]]];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return _devicesArray.count +1;
            break;
            
        default:
            return 0;
            break;
    }
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Item
    switch (indexPath.section) {
        case 0: {
            static NSString *CellIdentifier = @"labelTableViewCell";
            rcktLabelTableViewCell *cell = [tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier
                                            forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == _devicesArray.count) {
                cell.key.hidden=YES;
                cell.key.text = @"0";
                cell.lbl.text = @"Add Device";
                cell.lbl02.text = @"";
            }
            else {
                NSDictionary *item = [self.devicesArray objectAtIndex:indexPath.row];
                cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"name"]];
                cell.lbl02.text = [NSString stringWithFormat:@"%@", item[@"token"]];
                cell.key.hidden=NO;
                cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
                
            }
            return cell;
            break;
        }
        default: {
            static NSString *CellIdentifier = @"labelTableViewCell";
            rcktLabelTableViewCell *cell = [tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier
                                            forIndexPath:indexPath];
            return cell;
            break;
        }
    }
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.class == [rcktLabelTableViewCell class]) {
        rcktLabelTableViewCell *rc = (rcktLabelTableViewCell *) cell;
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        
        rcktDeviceFormsheet *vc = (rcktDeviceFormsheet *)[storyboard instantiateViewControllerWithIdentifier:@"DeviceFormsheet"];
        [vc setParams:rc.key.text dName:rc.lbl.text dToken:rc.lbl02.text];
        [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:vc animated:YES completion:nil];
        
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
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlSTR);
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getAllDevices",urlServer]]) {
        [self fetchDevicesData:htmlSTR];
        
    }
}

- (void)fetchDevicesData:(NSString *)html {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSString *key = [NSString stringWithFormat:@"device"];
    NSData *jsonData = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _devicesArray = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _devicesArray = [[NSMutableArray alloc] init];
        [_devicesArray addObject:[json objectForKey:key]];
    }
    if (refreshControl.isRefreshing)
        [refreshControl endRefreshing];
    [self.devicesTableView reloadData];
}



@end
