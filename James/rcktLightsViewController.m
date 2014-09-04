//
//  rcktLightsViewController.m
//  James
//
//  Created by Modesty & Roland on 25/06/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktLightsViewController.h"

@interface rcktLightsViewController ()

@end

@implementation rcktLightsViewController

@synthesize mycar;

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
    car.text = [NSString stringWithFormat:@"%@",mycar];
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

@end
