//
//  rckt.h
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rckt : NSObject

- (NSString*)GetServerURL;
- (void)showDoorbellFormsheet: (Boolean) playMusic sound:(NSString*)sound;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIActivityIndicatorView*) getActivityIndicator: (UIView*) view;

@end
