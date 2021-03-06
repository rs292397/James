//
//  rcktDeviceTokenFormsheet.m
//  James
//
//  Created by Modesty & Roland on 03/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktDeviceTokenFormsheet.h"
#import "rcktStringTableViewCell.h"
#import "rckt.h"
#import "rcktSplashViewController.h"

@interface rcktDeviceTokenFormsheet () 


@end

@implementation rcktDeviceTokenFormsheet


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
    [self buildNavbar];
    
    settings = @{@"Server settings" : @[
                         @[@"SERVERURL", @"URL", @"http://192.168.0.100"],
                         @[@"DEVICEID", @"Name", @"James iPad"],
                         @[@"PASSWORD", @"Password", @"0123456789abcdef"]
                         ]
                 };
    settingSectionTitles = [[settings allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (void)buildNavbar {

    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveSettings)];
    navitm.rightBarButtonItem = br;
}

- (void)addCancelButtonToNavbar {
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;
}

- (void)cmdCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveSettings {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *cells = [_settingsTableView visibleCells];
    
    for (rcktStringTableViewCell *cell in cells) {
        [prefs setObject:[NSString stringWithFormat:@"%@",cell.txt.text] forKey:cell.key.text];
    }
    [prefs synchronize];
    UIViewController *vc = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([vc isKindOfClass:[rcktSplashViewController class]]) {
            [(rcktSplashViewController*)vc initialize];
        }
    }];
/*
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"rcktSplash"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parentViewController presentViewController:controller animated:YES completion:^{
            [(rcktSplashViewController *)controller initialize];
        }];
    }];
  */
    
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *keyValue = [prefs objectForKey:[sectionSetting objectAtIndex:0]];
    if (keyValue!=nil)
        cell.txt.text = keyValue;
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[rckt alloc] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
*/

@end
