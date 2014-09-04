//
//  rcktAreasViewController.m
//  James
//
//  Created by Modesty & Roland on 25/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktAreasViewController.h"
#import "rcktArea2TableViewCell.h"
#import "rcktLightsViewController.h"


@interface rcktAreasViewController ()
{
    UIRefreshControl *refreshControl;
}

@end

@implementation rcktAreasViewController

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
    self.key = [NSString stringWithFormat:@"area"];
    [self doAPIrequest: [NSURL URLWithString:[NSString stringWithFormat:@"http://home.mkcloud.nl:8090/James/API/td/tt/getAllAreas"]]];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.1.90:8090/James/API/getAllAreas"]];
    //    [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:YES];
    //});

    //_areasDescription = @[
    //                          @{@"car" :@"Chevy"},
    //                          @{@"car" :@"BMW"},
    //                          @{@"car" :@"Toyota"},
    //                          @{@"car" :@"Volvo"},
    //                          @{@"car" :@"Smart"},
    //                          @{@"car" :@"Audi"}
    //                          ];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.attributedTitle = refreshString;
    [self.myTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)refreshTable
{
    //TODO
    [refreshControl endRefreshing];
    [self.myTableView reloadData];
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
- (void) doAPIrequest: (NSURL *)url {
    
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

    NSLog(@"%@", url.absoluteString);
    
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
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
    
    id itm = [json valueForKey:self.key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _areasDescription = [json objectForKey:self.key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _areasDescription = [[NSMutableArray alloc] init];
        [_areasDescription addObject:[json objectForKey:self.key]];
    }
    // TEST: Fetch Item
    //NSDictionary *item = [self.areasDescription objectAtIndex:0];
    //NSLog(@"%@: %@" , self.key, item[@"description"]);
    [self.myTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _areasDescription.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"areaCell01";
    rcktArea2TableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier
                                   forIndexPath:indexPath];
    // Fetch Item
    NSDictionary *item = [self.areasDescription objectAtIndex:indexPath.row];
    
    // Configure the cell...
    //long row = [indexPath row];
   
    UIView* square = cell.areaColor;
    square.backgroundColor = [UIColor blueColor];
    square.autoresizingMask= 0x3f;
    
    [cell setDidTapColorBlock:^(id sender) {
        NSLog(@"colortap");
     }];

    
    cell.areaDescription.text = [NSString stringWithFormat:@"%@",item[@"description"]];
    [cell.areaOnOff setOn:NO];
    [cell.areaSlider setValue:75.0 animated:YES];
    [cell setDidTapButtonBlock:^(id sender) {
        NSLog(@"%@", item[@"description"]);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"James" bundle:nil];
        rcktLightsViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"rcktLightsViewController"];
        sfvc.mycar=[NSString stringWithFormat:@"%@", item[@"description"]];
        
        UISplitViewController *svc = (UISplitViewController*) self.parentViewController;
        NSArray *va = [[NSArray alloc] initWithObjects:[svc.viewControllers objectAtIndex:0], sfvc, nil];
        [svc setViewControllers:va];
    }];

    [cell setDidSwitchOnOffBlock:^(id sender) {
        UISwitch* s = (UISwitch*) sender;
        if (s.on) {
            NSLog(@"Toggel On");
        } else {
            NSLog(@"Toggel Off");
        }
    }];

    [cell setDidSliderBlock:^(id sender) {
        UISlider* s = (UISlider*) sender;
        NSLog(@"%f", s.value);
    }];

    
    
    //    [cell.areaAction addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}
#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
    
}


@end
