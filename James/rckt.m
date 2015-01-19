//
//  rckt.m
//  James
//
//  Created by Modesty & Roland on 18/07/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//



//    _splashTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
//- (void)updateUI: (NSTimer*) timer {

    
#import "rckt.h"
#import "rcktDoorbellFormSheet.h"

@implementation rckt


- (NSString*)GetServerURL {
    
    //NSString *deviceName = [[UIDevice currentDevice] name];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //return [NSString stringWithFormat:@"%@/James/API/%@/%@",[prefs objectForKey:@"SERVERURL"],[deviceName stringByReplacingOccurrencesOfString:@" " withString:@"_"],[prefs objectForKey:@"DEVICETOKEN"]];
//    return [NSString stringWithFormat:@"http://192.168.1.104:8080/James/API/%@/%@",[prefs objectForKey:@"DEVICEID"], [prefs objectForKey:@"DEVICETOKEN"]];
    return [NSString stringWithFormat:@"%@/James/API/%@/%@",[prefs objectForKey:@"SERVERURL"],[prefs objectForKey:@"DEVICEID"], [prefs objectForKey:@"DEVICETOKEN"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor whiteColor].CGColor;  //[UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

-(void)showDoorbellFormsheet: (Boolean) playMusic{
    UIApplication *application = [UIApplication sharedApplication];

    UISplitViewController *svc;
    UIViewController *pvc;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [[application keyWindow].rootViewController isKindOfClass:[UISplitViewController class]]) {
        svc = (UISplitViewController*)[application keyWindow].rootViewController;
        pvc = svc.presentedViewController;
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        pvc = [application keyWindow].rootViewController.presentedViewController;
    }
    
    rcktDoorbellFormSheet *fs = nil;
        
        
    if ([pvc isKindOfClass:[rcktDoorbellFormSheet class]])
        fs = (rcktDoorbellFormSheet*) pvc;
    else {
        UIViewController *vc;
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vc = svc.viewControllers[1];
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        else {
            vc = [application keyWindow].rootViewController.presentedViewController;
            storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        }
        
        fs = (rcktDoorbellFormSheet*)[storyboard instantiateViewControllerWithIdentifier:@"DoorbellFormsheet"];
        [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [vc presentViewController:fs animated:YES completion:nil];
    }
        
    if (playMusic)
        [fs playDoorbellSound];
}

-(UIActivityIndicatorView*) getActivityIndicator: (UIView*) view {
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.alpha = 1.0;
    aiv.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    aiv.hidesWhenStopped = YES;
    return aiv;

}


@end
