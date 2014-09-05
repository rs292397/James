//
//  rcktSaveSceneFormsheet.h
//  James
//
//  Created by Modesty & Roland on 04/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktSaveSceneFormsheet : UIViewController {
    NSDictionary *settings;
    NSArray *settingSectionTitles;

}

@property (nonatomic, strong) NSString *areaID;

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITableView *valuesTableView;
@property (strong, nonatomic) NSIndexPath *scenePickerIndexPath;


@property (nonatomic, strong) NSMutableArray *scenesArray;
@property (strong, nonatomic) NSString *sceneSelectedID;
@property (strong, nonatomic) NSString *sceneNewName;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void)setParams:(NSString*) areaID;


@end
