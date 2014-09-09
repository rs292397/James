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
#import "rcktPickerTableViewCell.h"
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
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
 
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(cmdSaveScene)];
    navitm.rightBarButtonItem = br;
    [self fetchScenesData:self.areaID];
    self.sceneSelectedID=@"0";
    settings = @{@"" : @[
                         @[@"SCENE", @"Select", @"New scene", @"pickerTableViewCell"],
                         @[@"NAME", @"New name", @"all off", @"stringTableViewCell"]
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

    NSArray *cells = [self.valuesTableView visibleCells];
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[rcktStringTableViewCell class]]) {
            rcktStringTableViewCell *rcktCell = (rcktStringTableViewCell*) cell;
            if ([rcktCell.key.text isEqualToString:@"NAME"]) {
                self.sceneNewName = [NSString stringWithFormat:@"%@", rcktCell.txt.text];
                NSString *urlServer = [[rckt alloc] GetServerURL];
                NSString *postData = [NSString stringWithFormat:@"{\"description\":\"%@\", \"area\":\"%@\"}", self.sceneNewName, self.areaID];
                NSString *url = [NSString stringWithFormat:@"%@/saveScene/%@", urlServer, self.sceneSelectedID];
                [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];
            }
        }
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
    return (int)self.scenesArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *item = [self.scenesArray objectAtIndex:row];
    return item[@"description"];//[component];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSDictionary *item = [self.scenesArray objectAtIndex:row];
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.scenePickerIndexPath.row-1 inSection:self.scenePickerIndexPath.section];
    UITableViewCell* cell = [self.valuesTableView cellForRowAtIndexPath:index];
    if ([cell isKindOfClass:[rcktPickerTableViewCell class]]) {
        rcktPickerTableViewCell *rcktCell = (rcktPickerTableViewCell*)cell;
        self.sceneSelectedID = item[@"ID"];
        rcktCell.txt.text = item[@"description"];
    }
    index = [NSIndexPath indexPathForRow:self.scenePickerIndexPath.row+1 inSection:self.scenePickerIndexPath.section];
    cell = [self.valuesTableView cellForRowAtIndexPath:index];
    if ([cell isKindOfClass:[rcktStringTableViewCell class]]) {
        rcktStringTableViewCell *rcktCell = (rcktStringTableViewCell*)cell;
        rcktCell.txt.text = item[@"description"];
    }
}

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
    NSInteger numberOfRows = [sectionSettings count];
    if ([self scenePickerIsShown])
        numberOfRows ++;
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self scenePickerIsShown] && self.scenePickerIndexPath.row == indexPath.row) {
        static NSString *CellIdentifier = @"pickerValuesTableViewCell";
        UITableViewCell *cell = [tableView
                                         dequeueReusableCellWithIdentifier:CellIdentifier
                                         forIndexPath:indexPath];
        //UIPickerView *targetedPicker = (UIPickerView*) [cell viewWithTag:1];
        //targetedPicker =
        return cell;
    } else {
        NSString *sectionTitle = [settingSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionSettings = [settings objectForKey:sectionTitle];
        NSArray *sectionSetting = [sectionSettings objectAtIndex:indexPath.row];

        NSString *CellIdentifier = [sectionSetting objectAtIndex:3];
        UITableViewCell *cell = [tableView
                                         dequeueReusableCellWithIdentifier:CellIdentifier
                                         forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[rcktStringTableViewCell class]]) {
            rcktStringTableViewCell *rcktCell = (rcktStringTableViewCell*) cell;
            rcktCell.key.text = [sectionSetting objectAtIndex:0];
            rcktCell.lbl.text = [sectionSetting objectAtIndex:1];
            rcktCell.txt.placeholder = [sectionSetting objectAtIndex:2];
            rcktCell.txt.text = NULL;
            return rcktCell;
        } else if ([cell isKindOfClass:[rcktPickerTableViewCell class]]) {
            rcktPickerTableViewCell *rcktCell = (rcktPickerTableViewCell*) cell;
            rcktCell.key.text = [sectionSetting objectAtIndex:0];
            rcktCell.lbl.text = [sectionSetting objectAtIndex:1];
            rcktCell.txt.text = [sectionSetting objectAtIndex:2];
            return rcktCell;
        } else
            return cell;
    }
    
}

- (void)tableView: (UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView beginUpdates];
    NSIndexPath *indexPicker;
    if ([self scenePickerIsShown]) {
        if (indexPath.row != self.scenePickerIndexPath.row) {
            for (UITableViewCell* c in [tableView visibleCells]) {
                if ([c isKindOfClass:[rcktPickerTableViewCell class]]) {
                    rcktPickerTableViewCell *rcktCell = (rcktPickerTableViewCell*)c;
                    rcktCell.txt.textColor = [UIColor blackColor];
                }
            }
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:self.scenePickerIndexPath.row inSection:0]];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            self.scenePickerIndexPath = nil;
        }
    } else if (indexPath.row == 0) {
        indexPicker = [NSIndexPath indexPathForRow:self.scenePickerIndexPath.row inSection:0];
        rcktPickerTableViewCell *rcktCell = (rcktPickerTableViewCell*) [tableView cellForRowAtIndexPath:indexPicker];
        rcktCell.txt.textColor = self.view.tintColor;
        self.scenePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:self.scenePickerIndexPath.row inSection:0]];
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if ([self scenePickerIsShown] && self.scenePickerIndexPath.row == indexPath.row) {
        rowHeight = 162.0;
    }
    return rowHeight;
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
*/
- (BOOL)scenePickerIsShown{
    return self.scenePickerIndexPath != nil;
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

    UISplitViewController *svc = (UISplitViewController*)[self presentingViewController];
    rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)[svc.viewControllers objectAtIndex:1];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@", self.sceneSelectedID] forKey:@"ID"];
    [dic setObject:[NSString stringWithFormat:@"%@", self.sceneNewName] forKey:@"description"];
    if ([self.sceneSelectedID isEqualToString:@"0"])
        [vc didSaveScene:dic];
    else
        [vc didSaveScene:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
