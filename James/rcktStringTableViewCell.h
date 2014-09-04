//
//  rcktStringTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 17/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktStringTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UITextField *txt;
@property (weak, nonatomic) IBOutlet UILabel *key;

@end
