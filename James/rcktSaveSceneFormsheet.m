//
//  rcktSaveSceneFormsheet.m
//  James
//
//  Created by Modesty & Roland on 04/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSaveSceneFormsheet.h"
#import "rcktLightsDetailViewController.h"
#import "rcktStringTableViewCell.h"
#import "rckt.h"

@interface rcktSaveSceneFormsheet () 

@end

@implementation rcktSaveSceneFormsheet

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
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(cmdSaveScene)];
    navitm.rightBarButtonItem = br;
    [self fetchScenesData:self.areaID];
    settings = @{@"New Scene" : @[
                         @[@"NAME", @"Name", @"all off"]
                         ]
                 };
    settingSectionTitles = [[settings allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}

- (void)setParams:(NSString*) areaID; {
    self.areaID = areaID;
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSString stringWithFormat:@"0"] forKey:@"ID"];
    [dictionary setObject:[NSString stringWithFormat:@"New scene"] forKey:@"description"];
    
    _scenesArray = [[NSMutableArray alloc] init];
    [_scenesArray addObject:dictionary];
    for (NSDictionary *itm in list) {
        NSDictionary *area = itm[@"area"];
        if ([area[@"ID"] isEqualToString:areaID])
            [_scenesArray addObject:itm];
    }
    [self.picker reloadAllComponents];
}


- (void)cmdSaveScene {
    
    NSString *urlServer = [[rckt alloc] GetServerURL];
    NSString *postData;

    if ([self.picker selectedRowInComponent:0] == 0) {
        if (self.picker.hidden==NO) {
            self.valuesTableView.hidden = NO;
            self.picker.hidden = YES;
        } else {
            NSArray *cells = [_valuesTableView visibleCells];
            for (rcktStringTableViewCell *cell in cells) {
                if ([cell.key.text isEqualToString:@"NAME"]) {
                    postData = [NSString stringWithFormat:@"{\"description\":\"%@\", \"area\":\"%@\"}", cell.txt.text, self.areaID];
                    NSString *url = [NSString stringWithFormat:@"%@/saveScene/0", urlServer];
                    [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];

                }
            }
        }
    } else {
        NSDictionary *item = [self.scenesArray objectAtIndex:[self.picker selectedRowInComponent:0]];
        postData = [NSString stringWithFormat:@"{\"description\":\"%@\", \"area\":\"%@\"}", item[@"description"], self.areaID];
        NSString *url = [NSString stringWithFormat:@"%@/saveScene/%@", urlServer, item[@"ID"]];
        [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];

    }
}

- (void)cmdCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) doAPIrequestPUT: (NSURL*) url postData:(NSString*) postData{
    
    //NSLog(@"%@", url.absoluteString);
    //NSLog(@"%@", postData);
    
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


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.scenesArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *item = [self.scenesArray objectAtIndex:row];
    return item[@"description"];//[component];
}

/*
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row==0) {
        
    } else {
        NSDictionary *item = [self.scenesArray objectAtIndex:row];
        NSLog(@"%@", item[@"description"]);//[component];
    }
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [settingSectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [settingSectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [settingSectionTitles objectAtIndex:section];
    NSArray *sectionSettings = [settings objectForKey:sectionTitle];
    return [sectionSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"stringTableViewCell";
    rcktStringTableViewCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:CellIdentifier
                                     forIndexPath:indexPath];
    
    NSString *sectionTitle = [settingSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSettings = [settings objectForKey:sectionTitle];
    NSArray *sectionSetting = [sectionSettings objectAtIndex:indexPath.row];
    
    cell.key.text = [sectionSetting objectAtIndex:0];
    cell.lbl.text = [sectionSetting objectAtIndex:1];
    cell.txt.placeholder = [sectionSetting objectAtIndex:2];
    cell.txt.text = NULL;
    return cell;
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
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlSTR);

    UISplitViewController *svc = (UISplitViewController*)[self presentingViewController];
    rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)[svc.viewControllers objectAtIndex:1];
    [vc viewDidAppearScenes];
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
