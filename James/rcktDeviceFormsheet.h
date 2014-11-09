//
//  rcktDeviceFormsheet.h
//  James
//
//  Created by Modesty & Roland on 25/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktDeviceFormsheet : UIViewController <UIAlertViewDelegate> {
    NSDictionary *settings;
    NSArray *settingSectionTitles;
    NSString *urlServer;
    
    NSString *key;
    NSString *name;
    NSString *token;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (strong, nonatomic) IBOutlet UITableView *valuesTableView;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (void)setParams:(NSString *)key dName:(NSString *) dName dToken:(NSString *) dToken;

@end
