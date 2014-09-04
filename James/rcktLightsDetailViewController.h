//
//  rcktLightsDetailViewController.h
//  James
//
//  Created by Modesty & Roland on 19/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktLightsDetailViewController : UIViewController {
    IBOutlet UISegmentedControl *seg;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;

@property (nonatomic, strong) NSString *areaID;
@property (nonatomic, strong) NSString *areaDescription;

@property (nonatomic, strong) NSMutableArray *scenesArray;
@property (nonatomic, strong) NSMutableArray *lightsArray;

@property (strong, nonatomic) IBOutlet UITableView *lightsTableView;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (nonatomic, strong) UIActivityIndicatorView *actionIndicator;

- (void) reload: (NSString*)id description:(NSString*) description;
- (IBAction)segChange:(id)sender;
- (void) viewDidAppearLights;
- (void) viewDidAppearScenes;

@end
