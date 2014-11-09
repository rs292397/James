//
//  rcktColorFormsheet.m
//  James
//
//  Created by Modesty & Roland on 02/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktColorFormsheet.h"
#import "rcktColorPickerView.h"
#import "rcktLightsDetailViewController.h"
#import "rckt.h"

@interface rcktColorFormsheet ()

@property (nonatomic, strong) rcktColorPickerView* wheelView;

@end

@implementation rcktColorFormsheet

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
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    if (self.wheelView == nil)
    {
        self.wheelView = [[rcktColorPickerView alloc] initWithFrame:self.hueWheel.bounds];
        [self.wheelView initColor:[UIColor colorWithHue:fHue saturation:fSat brightness:1.0 alpha:1.0] lightID:lid];
        
        [self.hueWheel addSubview:self.wheelView];
    }

    [self buildNavbar];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)buildNavbar {
    
    UINavigationItem *navitm = self.navbaritem;
    navitm.title = [NSString stringWithFormat:@"Color for light %@", lid];
    UIBarButtonItem *br = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cmdDone)];
    navitm.rightBarButtonItem = br;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIBarButtonItem *bl;
    if ([prefs objectForKey:@"COLORPICKER"] != nil)
        bl = [[UIBarButtonItem alloc] initWithTitle:@"Paste" style:UIBarButtonItemStylePlain target:self action:@selector(cmdPaste)];
    else
        bl = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCopy)];
    self.navbaritem.leftBarButtonItem = bl;
}

- (void) cmdCopy {
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Paste" style:UIBarButtonItemStylePlain target:self action:@selector(cmdPaste)];
    self.navbaritem.leftBarButtonItem = bl;
    UIColor *c = [self.wheelView getColor];
    CGFloat hue;
    CGFloat sat;
    [c getHue:&hue saturation:&sat brightness:NULL alpha:NULL];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%f-%f", hue, sat] forKey:@"COLORPICKER"];
    [prefs synchronize];
}

- (void) cmdPaste {
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCopy)];
    self.navbaritem.leftBarButtonItem = bl;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [prefs objectForKey:@"COLORPICKER"];
    NSArray *colorStringArray = [colorString componentsSeparatedByString:@"-"];
    UIColor *color = [UIColor colorWithHue:[[colorStringArray objectAtIndex:0] floatValue] saturation:[[colorStringArray objectAtIndex:1] floatValue] brightness:1.0 alpha:1.0];
    [self.wheelView initColor:color lightID:lid];
    [self.wheelView sendColor];
    [prefs setObject:nil forKey:@"COLORPICKER"];
    [prefs synchronize];
    
    
}


- (void) cmdDone {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *svc = (UISplitViewController*)[self presentingViewController];
        UINavigationController *nav = [svc.viewControllers objectAtIndex:1];
        if ([nav.topViewController isKindOfClass:[rcktLightsDetailViewController class]]) {
            rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)nav.topViewController;
            [vc viewDidAppearLights];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        UINavigationController *nav = (UINavigationController*) self.presentingViewController;
        if ([[nav.childViewControllers objectAtIndex:2] isKindOfClass:[rcktLightsDetailViewController class]]) {
            rcktLightsDetailViewController *vc = (rcktLightsDetailViewController*)[nav.childViewControllers objectAtIndex:2];
            [vc viewDidAppearLights];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setParams:(NSString *)lightId cHue:(float) hue cSat:(float) sat {
    lid = lightId;
    fHue = hue;
    fSat = sat;
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
- (void) doAPIrequest: (NSURL *)url {
    
    //NSLog(@"%@", url.absoluteString);
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSLog(@"%@", [self.connection.currentRequest.URL absoluteString]);
    //NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:htmlSTR forKey:@"LIGHTS"];
    [prefs synchronize];
    
}


@end
