//
//  rcktCamerasViewController.m
//  James
//
//  Created by Modesty & Roland on 09/11/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktCamerasViewController.h"
#import "rckt.h"
#import "CoreGraphics/CoreGraphics.h"
#import "rcktCameraCollectionViewCell.h"
#import "rcktCameraFormSheet.h"
#import "rcktLabelTableViewCell.h"


@interface rcktCamerasViewController ()


@end


@implementation rcktCamerasViewController

#define END_MARKER_BYTES { 0xFF, 0xD9 }
static NSData *_endMarkerData = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewDidDisappear:(BOOL)animated {
    [self closeCam];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator = [[rckt alloc] getActivityIndicator:_image];
    [_image addSubview:self.activityIndicator];

    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //UIImageView
    if (_endMarkerData == nil) {
        uint8_t endMarker[2] = END_MARKER_BYTES;
        _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
    }
    
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeCam {
    [_connection cancel];
}

- (void)fetchData {
    
    NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
    //                                          encoding:NSUTF8StringEncoding];
    NSString *key = [NSString stringWithFormat:@"camera"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[prefs objectForKey:@"CAMERAS"]);
    NSData *jsonData = [[prefs objectForKey:@"CAMERAS"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    id itm = [json valueForKey:key];
    if ([itm isKindOfClass:[NSArray class]]) {
        _camerasArray = [json objectForKey:key];
    }
    else if ([itm isKindOfClass:[NSDictionary class]]) {
        _camerasArray = [[NSMutableArray alloc] init];
        [_camerasArray addObject:[json objectForKey:key]];
    }
    [self.cams reloadData];
    

}


-(void)viewDidLayoutSubviews{
    [self addImageToView];
}

/*
- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"willAnimate");

    [self addImageToView];
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) doAPIrequest: (NSURL *)url {
    //NSLog(@"%@", url.absoluteString);
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    //[_connection cancel];
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

    if (self.activityIndicator.isAnimating)
        [self.activityIndicator stopAnimating];

    [self.receivedData appendData:data];
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(0, _receivedData.length)];
    
    long endLocation = endRange.location + endRange.length;
    if (_receivedData.length >= endLocation) {
        NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(0, endLocation)];
        UIImage *receivedImage = [UIImage imageWithData:imageData];
        if (receivedImage) {
            _img = receivedImage;
            [self.image setImage:_img];
        }
    }
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
    
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _camerasArray.count;
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [self.camerasArray objectAtIndex:indexPath.row];
    
    rcktCameraCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cameraCollectionViewCell" forIndexPath:indexPath];
    
    cell.key.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    
    
    
    __weak rcktCameraCollectionViewCell *weakCell=cell;
    
    [cell setDidTapBlock:^(id sender) {
        
        [self.activityIndicator startAnimating];

        NSDictionary *item = [self.camerasArray objectAtIndex:[weakCell.key.text integerValue]];

        URLstream = [NSString stringWithFormat:@"%@",item[@"URLstream"]];
        ratio = [item[@"resolutionHeight"] floatValue] / [item[@"resolutionWidth"] floatValue];
        [self closeCam];
        [self doAPIrequest:[NSURL URLWithString:URLstream]];
        _img = nil;
        [_navbaritem setTitle:weakCell.lbl.text];
        [self addImageToView];

    }];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && indexPath.section==0 && indexPath.section==0) {
        [self.activityIndicator startAnimating];
        URLstream = [NSString stringWithFormat:@"%@",item[@"URLstream"]];
        ratio = [item[@"resolutionHeight"] floatValue] / [item[@"resolutionWidth"] floatValue];
        [self closeCam];
        [self doAPIrequest:[NSURL URLWithString:URLstream]];
        _img = nil;
        [_navbaritem setTitle:cell.lbl.text];
        [self addImageToView];
    }

    return cell;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _camerasArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.camerasArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"labelTableViewCell";
    rcktLabelTableViewCell *cell = [tableView
                                    dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    
    cell.lbl.text = [NSString stringWithFormat:@"%@", item[@"description"]];
    cell.key.text = [NSString stringWithFormat:@"%@", item[@"ID"]];
    cell.img.image = [UIImage imageNamed:@"camera_icon.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = [_camerasArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    rcktCameraFormSheet *vc = (rcktCameraFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"CameraFormSheet"];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    ratio = [[item objectForKey:@"resolutionHeight"] floatValue] / [[item objectForKey:@"resolutionWidth"] floatValue];
    [vc setStreamValues:[NSString stringWithFormat:@"%@", item[@"URLstream"]] ratio:ratio];
    [vc setTitle:[NSString stringWithFormat:@"%@", item[@"description"]]];
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)addImageToView {
    [_image setFrame: CGRectMake(_image.frame.origin.x, _image.frame.origin.y, _image.frame.size.width, _image.frame.size.width * ratio)];
    [_image setImage:_img];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] == _image) {
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        
        rcktCameraFormSheet *vc = (rcktCameraFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"CameraFormSheet"];
        [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [vc setStreamValues:URLstream ratio:ratio];
        [self presentViewController:vc animated:YES completion:nil];
    }
}



@end
