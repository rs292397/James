//
//  rcktLightsDetailViewController.m
//  James
//
//  Created by Modesty & Roland on 19/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktLightsDetailViewController.h"
#import "rcktColorFormsheet.h"
#import "rcktSaveSceneFormsheet.h"
#import "rcktSceneTableViewCell.h"
#import "rcktLightTableViewCell.h"
#import "rckt.h" 

@interface rcktLightsDetailViewController () {
    UIRefreshControl *refreshControl;
    NSString *urlServer;
}

@end

@implementation rcktLightsDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    urlServer = [[rckt alloc] GetServerURL];

    self.actionIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.actionIndicator.alpha = 1.0;
    self.actionIndicator.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    self.actionIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.actionIndicator];
    
    //Refresh control tableview
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.lightsTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    //self.areaID = [self getFirstArea];
    //[self fetchData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppearLights {
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
}
- (void) viewDidAppearScenes {
    seg.selectedSegmentIndex = 0;
    [self fetchData];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
}

- (void)refreshTable
{
    //TODO
    if (seg.selectedSegmentIndex == 0)
        [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
    else if (seg.selectedSegmentIndex == 1)
        [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];

}

- (void) reload:(NSString *)id description:(NSString *)description {
    _areaID = id;
    _areaDescription = description;
    [self fetchData];
}

- (void)fetchLightsData: (NSString *)areaID {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSMutableArray *list;
    NSString *key = [NSString stringWithFormat:@"light"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"LIGHTS"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        list = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        list = [[NSMutableArray alloc] init];
        [list addObject:[json objectForKey:key]];
    }
    _lightsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *itm in list) {
        NSDictionary *area = itm[@"area"];
        if ([area[@"ID"] isEqualToString:areaID])
            [_lightsArray addObject:itm];
    }
    [self.lightsTableView reloadData];
}

- (void)fetchScenesData: (NSString *)areaID {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSMutableArray *list;
    NSString *key = [NSString stringWithFormat:@"scene"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"SCENES"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        list = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        list = [[NSMutableArray alloc] init];
        [list addObject:[json objectForKey:key]];
    }
    _scenesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *itm in list) {
        NSDictionary *area = itm[@"area"];
        if ([area[@"ID"] isEqualToString:areaID])
            [_scenesArray addObject:itm];
    }
    [self.lightsTableView reloadData];
}
- (IBAction)segChange:(id)sender {
    [self fetchData];
    if (seg.selectedSegmentIndex == 1)
        [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
}

- (void)fetchData {
    UINavigationItem *navitm = self.navbaritem;
    if (seg.selectedSegmentIndex == 0) {
        navitm.title = [NSString stringWithFormat:@"Scenes"];
        navitm.rightBarButtonItem = nil;
        [self fetchScenesData:self.areaID];
    }
    else if (seg.selectedSegmentIndex == 1) {
        navitm.title = [NSString stringWithFormat:@"Lights"];
        UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(cmdSaveScene)];
        navitm.rightBarButtonItem = br;
        [self fetchLightsData:self.areaID];
    }
}

- (void)cmdSaveScene {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    rcktSaveSceneFormsheet *vc = (rcktSaveSceneFormsheet*)[storyboard instantiateViewControllerWithIdentifier:@"SaveSceneFormsheet"];
    [vc setParams:self.areaID];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:vc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _areaDescription;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (seg.selectedSegmentIndex==0)
        return _scenesArray.count;
    else if (seg.selectedSegmentIndex==1)
        return _lightsArray.count;
    else
        return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sceneTableViewCell";
    //SCENES SELECTED
    if (seg.selectedSegmentIndex==0) {
        // Fetch Item
        NSDictionary *item = [self.scenesArray objectAtIndex:indexPath.row];
        CellIdentifier = @"sceneTableViewCell";
        rcktSceneTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier
                                        forIndexPath:indexPath];
        cell.description.text = [NSString stringWithFormat:@"%@", item[@"description"]];
        cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];

        __weak rcktSceneTableViewCell *weakCell=cell;

        [cell setDidTapSceneBlock:^(id sender) {
            [self.actionIndicator startAnimating];
            NSString *url = [NSString stringWithFormat:@"%@/controlScene/%@", urlServer, weakCell.key.text];
            [self doAPIrequest: [NSURL URLWithString:url]];
        }];

        return cell;
    
    //LIGHTS SELECTED
    } else if (seg.selectedSegmentIndex==1) {
        // Fetch Item
        NSDictionary *item = [self.lightsArray objectAtIndex:indexPath.row];
        NSDictionary *strModel = item[@"model"];
        int model = [strModel[@"ID"] intValue];
        if (model==1)
            CellIdentifier = @"light02TableViewCell";
        else if (model==2||model==3)
            CellIdentifier = @"light01TableViewCell";
        
        rcktLightTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier

                                        forIndexPath:indexPath];
        cell.description.text = [NSString stringWithFormat:@"%@", item[@"description"]];
        cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
        if ([item[@"onOff"] isEqualToString:@"true"])
            [cell.onOff setOn:YES];
        else
            [cell.onOff setOn:NO];
        [cell.slider setValue:[item[@"bri"] floatValue] animated:YES];
        UIView* square = cell.color;
        square.backgroundColor = [UIColor colorWithHue:[item[@"hue"] floatValue]/360.0 saturation:[item[@"sat"] floatValue]/100.0 brightness:1.0 alpha:1.0];
        square.autoresizingMask= 0x3f;

        
        
        __weak rcktLightTableViewCell *weakCell=cell;

        [cell setDidSwitchOnOffBlock:^(id sender) {
            UISwitch *s = (UISwitch*) sender;
            NSString *postData;
            if (s.on)
                postData = [NSString stringWithFormat:@"{\"command\":\"1\", \"on\":\"true\", \"bri\": \"0\"}"];
            else
                postData = [NSString stringWithFormat:@"{\"command\":\"1\", \"on\":\"false\", \"bri\": \"0\"}"];
            
            NSString *url = [NSString stringWithFormat:@"%@/controlLight/%@", urlServer, weakCell.key.text];
            [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
        }];
        
        [cell setDidSliderBlock:^(id sender) {
            UISlider* s = (UISlider*) sender;
            NSString *postData;
            int val = (int) s.value;
            if (s.value>0)
                postData = [NSString stringWithFormat:@"{\"command\":\"2\", \"on\":\"true\", \"bri\": \"%d\"}", val];
            else
                postData = [NSString stringWithFormat:@"{\"command\":\"1\", \"on\":\"false\", \"bri\": \"0\"}"];
            NSString *url = [NSString stringWithFormat:@"%@/controlLight/%@", urlServer, weakCell.key.text];
            [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
        }];
        
        [cell setDidTapColorBlock:^(id sender) {
            UIColor *c = weakCell.color.backgroundColor;
            CGFloat h;
            CGFloat s;
            [c getHue:&h saturation:&s brightness:NULL alpha:NULL];
     
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            rcktColorFormsheet *vc = (rcktColorFormsheet*)[storyboard instantiateViewControllerWithIdentifier:@"ColorFormsheet"];
            [vc setParams:weakCell.key.text cHue:h cSat:s];
            [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:vc animated:YES completion:nil];

        }];
        
        
        return cell;
    }
    else {
        rcktSceneTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier
                                        forIndexPath:indexPath];
        
        return cell;
    }
}

- (void) doAPIrequest: (NSURL *)url {
    //NSLog(@"%@", url.absoluteString);
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
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
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
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
    //NSLog(@"%@", connection.originalRequest.URL.absoluteString);
    //NSLog(@"%@", connection.currentRequest.URL.absoluteString);
    
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getAll",urlServer]]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([urlConnection isEqualToString:[NSString stringWithFormat:@"%@/getAllScenes",urlServer]])
            [prefs setObject:htmlSTR forKey:@"SCENES"];
        else if ([urlConnection isEqualToString:[NSString stringWithFormat:@"%@/getAllLights",urlServer]])
            [prefs setObject:htmlSTR forKey:@"LIGHTS"];
        [prefs synchronize];
        if (refreshControl.isRefreshing)
            [refreshControl endRefreshing];
        [self fetchData];
    } else {
        if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/deleteScene",urlServer]]) {
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
        } else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/controlScene",urlServer]]) {
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
        }
        [self.actionIndicator stopAnimating];
    }
}


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
         if (cell.class == [rcktSceneTableViewCell class]) {
             NSString *key = [NSString stringWithFormat:@"%@",((rcktSceneTableViewCell*)cell).key.text];
             [self.actionIndicator startAnimating];
             [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/deleteScene/%@", urlServer,key]]];
         }

     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
