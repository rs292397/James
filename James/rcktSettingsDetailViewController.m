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
    [self navigationItem].title = @"Settings";
    settingsItems = @{@"Physical Devices" : @[
                          @[@"segueSettingsDevices", @"Devices", @"*.png"]
                          ]//,
                  };
    
    settingsItemSectionTitles = [[settingsItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    rcktLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelTableViewCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [settingsItemSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSettingsItems = [settingsItems objectForKey:sectionTitle];
    NSArray *sectionSettingsItem = [sectionSettingsItems objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    cell.key.text = [sectionSettingsItem objectAtIndex:0];
    cell.lbl.text = [sectionSettingsItem objectAtIndex:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.img.image = [UIImage imageNamed:[sectionSettingsItem objectAtIndex:2]];
    
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



@end
