//
//  rcktScenariosDetailViewController.m
//  James
//
//  Created by Modesty & Roland on 19/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktScenariosDetailViewController.h"
#import "rcktLabelTableViewCell.h"
#import "rckt.h"

@interface rcktScenariosDetailViewController ()

@end

@implementation rcktScenariosDetailViewController

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
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //Refresh control tableview
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.scenariosTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllButtons/3", urlServer]]];
    [self navigationItem].title = @"Scenarios";
}

- (void) viewDidAppear:(BOOL)animated {
    [self fetchData];
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

- (void)refreshTable
{
    //TODO
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"%@/getAllButtons/3", urlServer]]];
}

- (void)fetchData {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSString *key = [NSString stringWithFormat:@"button"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"SCENARIOS"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _scenariosArray = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _scenariosArray = [[NSMutableArray alloc] init];
        [_scenariosArray addObject:[json objectForKey:key]];
    }
    [self.scenariosTableView reloadData];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _scenariosArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Item
    NSDictionary *item = [self.scenariosArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"labelTableViewCell";
    rcktLabelTableViewCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
    cell.img.image = [UIImage imageNamed:@"scenario_icon.png"];
    if ([item[@"state"] isEqualToString:@"true"])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    NSDictionary *itm = [self.scenariosArray objectAtIndex:indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@/controlButton/%@", urlServer, itm[@"ID"]];
    [self doAPIrequest:[NSURL URLWithString:url]];
 
    for (UITableViewCell* cell in [self.scenariosTableView visibleCells]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
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
    if ([urlConnection hasPrefix:[NSString stringWithFormat:@"%@/getAll",urlServer]]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:htmlSTR forKey:@"SCENARIOS"];
        [prefs synchronize];
        if (refreshControl.isRefreshing)
            [refreshControl endRefreshing];
        [self fetchData];
    }
}


@end
