//
//  rcktRootCollectionViewController.m
//  James
//
//  Created by Modesty & Roland on 15/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktRootCollectionViewController.h"
#import "rcktLabelCollectionViewCell.h"
#import "rcktColorFormsheet.h"

@interface rcktRootCollectionViewController ()

@end

@implementation rcktRootCollectionViewController

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rootItems = @[
                      @[@"SCENARIOS_DETAILVIEW", @"Scenarios", @"scenario_icon.png"],
                      @[@"LIGHTS_DETAILVIEW", @"Lights", @"light_icon.png"],
                      @[@"SHADES_DETAILVIEW", @"Shades", @"shade_icon.png"],
                      @[@"CAMERAS_DETAILVIEW", @"Cameras", @"camera_icon.png"],
                      @[@"DOORBELL_DETAILVIEW", @"Doorbell", @"doorbell_icon.png"],
                      @[@"SETTINGS_DETAILVIEW", @"Settings", @"settings_icon.png"]
                      ];
    }
    else {
        rootItems = @[
                      @[@"SCENARIOS_DETAILVIEW", @"Scenarios", @"scenario_icon.png"],
                      @[@"AREAS_VIEW", @"Lights", @"light_icon.png"],
                      @[@"SHADES_DETAILVIEW", @"Shades", @"shade_icon.png"],
                      @[@"CAMERAS_DETAILVIEW", @"Cameras", @"camera_icon.png"],
                      @[@"DOORBELL_DETAILVIEW", @"Doorbell", @"doorbell_icon.png"],
                      @[@"SETTINGS_DETAILVIEW", @"Settings", @"settings_icon.png"]
                      ];
    }
    self.navigationItem.title = @"James";
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

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [rootItems count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    rcktLabelCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"labelCollectionViewCell" forIndexPath:indexPath];
    
    NSArray *sectionRootItem = [rootItems objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    cell.key.text = [sectionRootItem objectAtIndex:0];
    cell.lbl.text = [sectionRootItem objectAtIndex:1];
    cell.img.image = [UIImage imageNamed:[sectionRootItem objectAtIndex:2]];
    cell.img.layer.cornerRadius = 5.0f;
    cell.img.layer.borderWidth = 1.0f;
    cell.img.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    __weak rcktLabelCollectionViewCell *weakCell=cell;
    
    [cell setDidTapBlock:^(id sender) {
        
        NSString *key = weakCell.key.text;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //NSLog(@"Selected: %@",key);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *sfvc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:key];
            UINavigationController *nav = (UINavigationController*) self.parentViewController;
            UISplitViewController *svc = (UISplitViewController*) nav.parentViewController;
            
            if ([key isEqualToString:@"LIGHTS_DETAILVIEW"]) {
                [self performSegueWithIdentifier:@"segueMasterNavAreas" sender:@"me"];
            }
            
            NSArray *va = [[NSArray alloc] initWithObjects:[svc.viewControllers objectAtIndex:0], sfvc, nil];
            [svc setViewControllers:va];
        }
        else {
            //NSLog(@"Selected: %@",key);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            UIViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:key];
            [self.navigationController pushViewController:sfvc animated:YES];
        }
        
    }];

    return cell;
    
    
}

@end
