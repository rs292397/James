//
//  rcktSettingsDetailViewController.m
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktSettingsDetailViewController.h"

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
    [self buildNavbar];
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

- (void)buildNavbar {
    
    UINavigationBar *navbar = [[UINavigationBar alloc] init];
    navbar.frame = CGRectMake(0,0,self.view.frame.size.width, 64);
    [navbar setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
    //UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSettings)];
    UINavigationItem *navitm = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    //navitm.rightBarButtonItem = b;
    [navbar pushNavigationItem:navitm animated:YES];
    [self.view addSubview:navbar];
}

@end
