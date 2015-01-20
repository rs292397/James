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
#import "rcktLabelTableViewCell.h"
#import "rcktSwitchTableViewCell.h"
#import "rcktLightTableViewCell.h"
#import "rckt.h" 

@interface rcktLightsDetailViewController ()

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
    rckt *r = [rckt alloc];
    urlServer = [r GetServerURL];
    self.activityIndicator = [r getActivityIndicator:self.view];
    [self.view addSubview:self.activityIndicator];
    
    //Refresh control tableview
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.lightsTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    //self.areaID = [self getFirstArea];
    //[self fetchData];
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    [self fetchData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppearLights {
}

- (void)didSaveScene:(NSMutableDictionary*)itm {
    seg.selectedSegmentIndex = 0;
    [self fetchData];
    if (itm!=nil) {
        [self.scenesArray addObject:itm];
        [self.lightsTableView beginUpdates];
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self.scenesArray count]-1 inSection:1];
        NSArray *indexPaths = @[index];
        [self.lightsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.lightsTableView endUpdates];
    }
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
    bool areaButtonCheck = NO;
    for (NSDictionary *itm in list) {
        NSDictionary *area = itm[@"area"];
        if ([area[@"ID"] isEqualToString:areaID]) {
            if (!areaButtonCheck) {
                areaButtonCheck = YES;
                NSDictionary *areaButton = area[@"button"];
                areaHasSwitch = (areaButton!=nil);
                areaSwitchState = [areaButton[@"state"] isEqualToString:@"true"];
            }
            [_lightsArray addObject:itm];
        }
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
    bool areaButtonCheck = NO;
    for (NSDictionary *itm in list) {
        NSDictionary *area = itm[@"area"];
        if ([area[@"ID"] isEqualToString:areaID]) {
            if (!areaButtonCheck) {
                areaButtonCheck = YES;
                NSDictionary *areaButton = area[@"button"];
                areaHasSwitch = (areaButton!=nil);
                if (areaHasSwitch) {
                    areaSwitchID = areaButton[@"ID"];
                    areaSwitchState = [areaButton[@"state"] isEqualToString:@"true"];
                }
            }
            [_scenesArray addObject:itm];
        }
    }
    [self.lightsTableView reloadData];
}
- (IBAction)segChange:(id)sender {
//    [self fetchData];
    NSString *type;
    if (seg.selectedSegmentIndex == 0)
        type=@"Scenes";
    else
        type=@"Lights";
    
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAll%@", urlServer, type]]];
    [self fetchData];
}

- (void)fetchData {
    UINavigationItem *navitm = [self navigationItem];
    if (_areaDescription!=nil) {
        navitm.title = [NSString stringWithFormat:@"%@", _areaDescription];
    }
    if (seg.selectedSegmentIndex == 0) {
        navitm.rightBarButtonItem = nil;
        [self fetchScenesData:self.areaID];
    }
    else if (seg.selectedSegmentIndex == 1) {
        UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(cmdSaveScene)];
        navitm.rightBarButtonItem = br;
        [self fetchLightsData:self.areaID];
    }
}

- (void)cmdSaveScene {
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];

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
    if (seg.selectedSegmentIndex==0)
        return 2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil; //_areaDescription;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numberOfRows = 0;
    if (seg.selectedSegmentIndex==0)
        if (section == 0)
            numberOfRows = areaHasSwitch ? 1 : 0;
        else
            numberOfRows = _scenesArray.count;
    else if (seg.selectedSegmentIndex==1)
        numberOfRows = _lightsArray.count;
    return numberOfRows;
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (seg.selectedSegmentIndex==0)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sceneTableViewCell";
    //SCENES SELECTED
    if (seg.selectedSegmentIndex==0) {
        UITableViewCell *cell;
        if (indexPath.section == 0) {
            CellIdentifier = @"switchTableViewCell";
            rcktSwitchTableViewCell *itmCell = [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier
                                               forIndexPath:indexPath];
            itmCell.key.text = @"0";
            itmCell.lbl.text = @"Switch";
            [itmCell.swtch setOn:areaSwitchState];
            
            [itmCell setDidSwitchOnOffBlock:^(id sender) {
                NSString *url = [NSString stringWithFormat:@"%@/controlButton/%@", urlServer, areaSwitchID];
                [self doAPIrequest:[NSURL URLWithString:url]];
            }];

            cell = itmCell;
        }
        else {
            // Fetch Item
            NSDictionary *item = [self.scenesArray objectAtIndex:indexPath.row];
            CellIdentifier = @"sceneTableViewCell";
            rcktLabelTableViewCell *itmCell = [tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier
                                            forIndexPath:indexPath];
            itmCell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
            itmCell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
            itmCell.img.image = [UIImage imageNamed:@"switch_icon.png"];
            cell = itmCell;
        }
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
        cell.txt.text = [NSString stringWithFormat:@"%@", item[@"description"]];
        cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
        if ([item[@"onOff"] isEqualToString:@"true"])
            [cell.onOff setOn:YES];
        else
            [cell.onOff setOn:NO];
        [cell.slider setValue:[item[@"bri"] floatValue] animated:YES];
        UIView* square = cell.color;
        square.layer.borderColor = tableView.layer.backgroundColor;
        square.layer.borderWidth = 1.0f;
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
            if (model==3) {
                UIColor *c = weakCell.color.backgroundColor;
                CGFloat h;
                CGFloat s;
                [c getHue:&h saturation:&s brightness:NULL alpha:NULL];
                
                UIStoryboard *storyboard;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                else
                    storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                
                rcktColorFormsheet *vc = (rcktColorFormsheet*)[storyboard instantiateViewControllerWithIdentifier:@"ColorFormsheet"];
                [vc setParams:weakCell.key.text cHue:h cSat:s];
                [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }];
        
        
        return cell;
    }
    else {
        rcktLabelTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier
                                        forIndexPath:indexPath];
        
        return cell;
    }
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
*/

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (seg.selectedSegmentIndex==0)
            return 60;
        else
            return 110;
    }
    else
        return 60;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (seg.selectedSegmentIndex==0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.class == [rcktLabelTableViewCell class]) {
                [tableView beginUpdates];
                NSArray *indexPaths = @[indexPath];
                [self.scenesArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
                NSString *key = [NSString stringWithFormat:@"%@",((rcktLabelTableViewCell*)cell).key.text];
                [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/deleteScene/%@", urlServer,key]]];
                
                
            }
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (seg.selectedSegmentIndex==0 && indexPath.section==1) {
        NSDictionary *itm = [self.scenesArray objectAtIndex:indexPath.row];
        [self.activityIndicator startAnimating];
        NSString *url = [NSString stringWithFormat:@"%@/controlScene/%@", urlServer, itm[@"ID"]];
        [self doAPIrequest: [NSURL URLWithString:url]];
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
            NSError* error;
            NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            if ([[json objectForKey:@"code"] intValue]<0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Could not delete the scene because of references." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            }
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllScenes", urlServer]]];
        } else if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/controlScene",urlServer]]) {
            [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllLights", urlServer]]];
        }
        [self.activityIndicator stopAnimating];
    }
}



@end
