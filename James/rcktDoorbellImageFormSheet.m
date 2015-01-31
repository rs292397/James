//
//  rcktDoorbellImageFormSheet.m
//  James
//
//  Created by Modesty en Roland on 31/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import "rcktDoorbellImageFormSheet.h"

@interface rcktDoorbellImageFormSheet ()

@end

@implementation rcktDoorbellImageFormSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationItem *navitm = self.navbaritem;
    UIBarButtonItem *bl = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cmdCancel)];
    navitm.leftBarButtonItem = bl;

}

-(void)viewDidLayoutSubviews{
    [self addImageToView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self addImageToView];
}

- (void)cmdCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setImage:(UIImage*)img{
    _img = img;
}

-(void)addImageToView {
    [_imgView setFrame: CGRectMake(_imgView.frame.origin.x, _imgView.frame.origin.y, _imgView.frame.size.width, _imgView.frame.size.width * (_img.size.height/_img.size.width))];
    [_imgView setImage:_img];
}
@end
