//
//  rcktRootTableViewController.m
//  James
//
//  Created by Modesty & Roland on 17/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktRootTableViewController.h"
#import "rcktLabelTableViewCell.h"
#import "rcktSettingsDetailViewController.h"

@interface rcktRootTableViewController ()


@end

@implementation rcktRootTableViewController

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
    rootItems = @{@"Lights" : @[
                          @[@"LIGHTS_DETAILVIEW", @"Lights", @"light_icon.png"]
                          ],
                  @"Scenarios" : @[
                          @[@"SCENARIOS_DETAILVIEW", @"Scenarios", @"scenario_icon.png"]
                          ],
                  @"Settings" : @[
                          @[@"SETTINGS_DETAILVIEW", @"Settings", @"switch_icon.png"]
                          ]
                  };

    rootItemSectionTitles = [[rootItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    [self tableView:self.rootTableView didSelectRowAtIndexPath:index];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [rootItemSectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [rootItemSectionTitles objectAtIndex:section];
    NSArray *sectionRootItems = [rootItems objectForKey:sectionTitle];
    return [sectionRootItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    rcktLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelTableViewCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [rootItemSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionRootItems = [rootItems objectForKey:sectionTitle];
    NSArray *sectionRootItem = [sectionRootItems objectAtIndex:indexPath.row];

    
    // Configure the cell...
    cell.key.text = [sectionRootItem objectAtIndex:0];
    cell.lbl.text = [sectionRootItem objectAtIndex:1];
    cell.img.image = [UIImage imageNamed:[sectionRootItem objectAtIndex:2]];
    
    return cell;
}

#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.class == [rcktLabelTableViewCell class]) {
        NSString *key = [NSString stringWithFormat:@"%@",((rcktLabelTableViewCell*)cell).key.text];
        //NSLog(@"Selected: %@",key);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:key];
        UINavigationController *nav = (UINavigationController*) self.parentViewController;
        UISplitViewController *svc = (UISplitViewController*) nav.parentViewController;

        if ([key isEqualToString:@"LIGHTS_DETAILVIEW"]) {
            [self performSegueWithIdentifier:@"segueMasterNavAreas" sender:@"me"];
        }
        
        NSArray *va = [[NSArray alloc] initWithObjects:[svc.viewControllers objectAtIndex:0], sfvc, nil];
        [svc setViewControllers:va];
        //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
