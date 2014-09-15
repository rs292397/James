//
//  rcktRootCollectionViewController.h
//  James
//
//  Created by Modesty & Roland on 15/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktRootCollectionViewController : UICollectionViewController {
    NSArray *rootItems;
}

@property (strong, nonatomic) IBOutlet UICollectionView *rootCollectionView;

@end
