//
//  rcktTestViewController.h
//  James
//
//  Created by Modesty & Roland on 22/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktTestViewController : UIViewController
{
    IBOutlet UILabel *testlabel;
}

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) IBOutlet UIButton *btn_syncronous;
@property (retain, nonatomic) IBOutlet UIButton *btn_post;
@property (retain, nonatomic) IBOutlet UIButton *btn_get;
@property (retain, nonatomic) NSMutableData *receivedData;

-(IBAction)btn_get_clicked:(id)sender;
-(IBAction)btn_post_clicked:(id)sender;

-(IBAction)Button:(id)sender;

@end
