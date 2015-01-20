//
//  rcktShadesViewController.m
//  James
//
//  Created by Modesty & Roland on 20/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktShadesViewController.h"
#import "rckt.h"
#import "rcktShadeTableViewCell.h"

@interface rcktShadesViewController ()

@end

@implementation rcktShadesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rckt *r = [rckt alloc];
    urlServer = [r GetServerURL];
    self.activityIndicator = [r getActivityIndicator:self.view];
    [self.view addSubview:self.activityIndicator];
    
    //Refresh control tableview
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.shadesTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    //self.areaID = [self getFirstArea];
    //[self fetchData];
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    [self fetchData];

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

- (void)refreshTable
{
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllShades", urlServer]]];
}

- (void)fetchData {
    
    NSError* error;
    NSString *key = [NSString stringWithFormat:@"shade"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"SHADES"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    
    _shadesArray = [[NSMutableArray alloc] init];
    if ([itm isKindOfClass:[NSMutableArray class]]) {
        for (NSDictionary *itm in [json objectForKey:key])
            [_shadesArray addObject:itm];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        [_shadesArray addObject:[json objectForKey:key]];
    }
    [self.shadesTableView reloadData];
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
    
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //set http method
    [request setHTTPMethod:@"PUT"];
    //initialize a post data
    //NSString *postData = [NSString stringWithFormat:@"j_username=role&j_password=tomcat"];
    //set request content type we MUST set this value.
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getAll",urlServer]]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([urlConnection isEqualToString:[NSString stringWithFormat:@"%@/getAllShades",urlServer]])
            [prefs setObject:htmlSTR forKey:@"SHADES"];
        [prefs synchronize];
        if (refreshControl.isRefreshing)
            [refreshControl endRefreshing];
        [self fetchData];
    }
    else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/control",urlServer]]) {
        [self.activityIndicator stopAnimating];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _shadesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shadeTableViewCell";
    NSDictionary *item = [self.shadesArray objectAtIndex:indexPath.row];
    rcktShadeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    cell.img.image = [UIImage imageNamed:@"shade_icon.png"];
    if ([item[@"type"] isEqualToString:@"0"]) {
        [cell.cmdOpen setImage:[UIImage imageNamed:@"Open.png"] forState:UIControlStateNormal];
        [cell.cmdClose setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.cmdOpen setImage:[UIImage imageNamed:@"Up.png"] forState:UIControlStateNormal];
        [cell.cmdClose setImage:[UIImage imageNamed:@"Down.png"] forState:UIControlStateNormal];
    }

    
    __weak rcktShadeTableViewCell *weakCell=cell;
    [cell setDidTapOpenBlock:^(id sender) {
        NSString *postData;
        postData = [NSString stringWithFormat:@"{\"command\":\"111\"}"];
        NSString *url = [NSString stringWithFormat:@"%@/controlShade/%@", urlServer, weakCell.key.text];
        [self.activityIndicator startAnimating];
        [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
    }];
    [cell setDidTapCloseBlock:^(id sender) {
        NSString *postData;
        postData = [NSString stringWithFormat:@"{\"command\":\"110\"}"];
        NSString *url = [NSString stringWithFormat:@"%@/controlShade/%@", urlServer, weakCell.key.text];
        [self.activityIndicator startAnimating];
        [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
    }];

    
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
    
    NSDictionary *itm = [self.shadesArray objectAtIndex:indexPath.row];
    [self.activityIndicator startAnimating];
    NSString *url = [NSString stringWithFormat:@"%@/controlShade/%@", urlServer, itm[@"ID"]];
    [self doAPIrequest: [NSURL URLWithString:url]];
    
}




@end
