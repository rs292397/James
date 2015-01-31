//
//  rcktDoorbellImageFormSheet.h
//  James
//
//  Created by Modesty en Roland on 31/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktDoorbellImageFormSheet : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navbaritem;
@property (strong, retain) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) UIImage *img;


-(void)setImage:(UIImage*)img;
@end
