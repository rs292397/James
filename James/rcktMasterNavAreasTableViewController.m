//
//  rcktMasterNavAreasTableViewController.m
//  James
//
//  Created by Modesty & Roland on 28/08/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktMasterNavAreasTableViewController.h"
#import "rcktLabelTableViewCell.h"
#import "rcktLightsDetailViewController.h"

@interface rcktMasterNavAreasTableViewController ()

@end

@implementation rcktMasterNavAreasTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchData {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSString *key = [NSString stringWithFormat:@"area"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *jsonData = [[prefs objectForKey:@"AREAS"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _areasArray = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _areasArray = [[NSMutableArray alloc] init];
        [_areasArray addObject:[json objectForKey:key]];
    }
    [self.areasTableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.areasTableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.areasTableView didSelectRowAtIndexPath:indexPath];
    }

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return _areasArray.count;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 1;
    else
        return _areasArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Item
    NSDictionary *item;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        item = [self.areasArray objectAtIndex:indexPath.section];
    else
        item = [self.areasArray objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"labelTableViewCell";
    rcktLabelTableViewCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
    cell.img.image = [UIImage imageNamed:@"area_icon.png"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.class == [rcktLabelTableViewCell class]) {
        NSString *key = [NSString stringWithFormat:@"%@",((rcktLabelTableViewCell*)cell).key.text];
        NSString *description = [NSString stringWithFormat:@"%@",((rcktLabelTableViewCell*)cell).lbl.text];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *nav = (UINavigationController*) self.parentViewController;
            UISplitViewController *svc = (UISplitViewController*) nav.parentViewController;
            UINavigationController *nav2 = [svc.viewControllers objectAtIndex:1];
            rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)nav2.topViewController;
            //rcktLightsDetailViewController *vc = [svc.viewControllers objectAtIndex:1];
            [vc reload:key description:description];
        }
        else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            UIViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"LIGHTS_VIEW"];
            if ([sfvc isKindOfClass:[rcktLightsDetailViewController class]]) {
                rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)sfvc;
                [vc reload:key description:description];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }

    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
