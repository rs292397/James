//
//  rcktSettingsDetailViewController.m
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSettingsDetailViewController.h"
#import "rckt.h"
#import "rcktLabelTableViewCell.h"
#import "rcktSwitchTableViewCell.h"
#import "rcktSplashViewController.h"

@interface rcktSettingsDetailViewController ()

@end

@implementation rcktSettingsDetailViewController

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

    prefs = [NSUserDefaults standardUserDefaults];

    [self navigationItem].title = @"Settings";
    settingsItems = @{@"Physical Devices" : @[
                          @[@"menu", @"segueSettingsDevices", @"Devices", @"*.png"]
                          ],
                      @"General" : @[
                              @[@"item", @"NOTIFY_DOORBELL", @"Allow Notifications from Doorbell", @"*.png"]
                              ]
                      };
    
    settingsItemSectionTitles = [[settingsItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [settingsItemSectionTitles count];
}


- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    return [settingsItemSectionTitles objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [settingsItemSectionTitles objectAtIndex:section];
    NSArray *sectionSettingsItems = [settingsItems objectForKey:sectionTitle];
    return [sectionSettingsItems count];
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *sectionTitle = [settingsItemSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSettingsItems = [settingsItems objectForKey:sectionTitle];
    NSArray *sectionSettingsItem = [sectionSettingsItems objectAtIndex:indexPath.row];
    
    if ([[sectionSettingsItem objectAtIndex:0] isEqualToString:@"menu"]) {
        rcktLabelTableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"labelTableViewCell" forIndexPath:indexPath];
            
        // Configure the cell...
        menuCell.key.text = [sectionSettingsItem objectAtIndex:1];
        menuCell.lbl.text = [sectionSettingsItem objectAtIndex:2];
        menuCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.img.image = [UIImage imageNamed:[sectionSettingsItem objectAtIndex:2]];
        cell = menuCell;
    }
    else if ([[sectionSettingsItem objectAtIndex:0] isEqualToString:@"item"]) {
        rcktSwitchTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"switchTableViewCell" forIndexPath:indexPath];
        itemCell.key.text = [sectionSettingsItem objectAtIndex:1];
        itemCell.lbl.text = [sectionSettingsItem objectAtIndex:2];
        [itemCell.swtch setOn:[prefs boolForKey:@"NOTIFY_DOORBELL"]];
        __weak rcktSwitchTableViewCell *weakCell=itemCell;
        
        [itemCell setDidSwitchOnOffBlock:^(id sender) {
            UISwitch *s = (UISwitch*) sender;
            NSString *key = [NSString stringWithFormat:@"%@", weakCell.key.text];
            [prefs setBool:s.on forKey:key];
            [prefs synchronize];

            NSString *postData = [NSString stringWithFormat:@"{\"iosToken\":\"%@\", \"iosNotifyDoorbell\":%s}", [prefs objectForKey:@"NOTIFICATION_TOKEN"],[prefs boolForKey:@"NOTIFY_DOORBELL"]? "true" : "false"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[rckt alloc] GetServerURL]]];
            [self doAPIrequestPUT:url postData:postData];

        }];

        cell = itemCell;

    }
    
    
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.class == [rcktLabelTableViewCell class]) {
        NSString *key = [NSString stringWithFormat:@"%@",((rcktLabelTableViewCell*)cell).key.text];
        [self performSegueWithIdentifier:key sender:@"me"];
    }
}


- (void) doAPIrequest: (NSURL *)url {
    //NSLog(@"%@", url.absoluteString);
    [self.activityIndicator startAnimating];
  
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
    [self.activityIndicator startAnimating];
    
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
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlSTR);
    NSString *urlConnection = connection.originalRequest.URL.absoluteString;
    if ([[[rckt alloc] GetServerURL] isEqualToString:urlConnection]) {
        NSData *jsonData = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSString *keyCode = [json valueForKey:@"code"];
        if (keyCode!=nil) {
            NSInteger code = [keyCode integerValue];
            if (code<0) {
                NSLog(@"fout");
            } else {
                [prefs setObject:[NSString stringWithFormat:@"%@", [json valueForKey:@"message"]] forKey:@"DEVICETOKEN"];
                [prefs synchronize];
          }
        }
    }
    [self.activityIndicator stopAnimating];

}

@end
