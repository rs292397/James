//
//  rcktMessageTableViewCell.h
//  James
//
//  Created by Modesty & Roland on 13/01/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcktMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *key;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;


@end
