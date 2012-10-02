//
//  UISplitViewController+autoRotate.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 2 Oct.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "UISplitViewController+autoRotate.h"

@implementation UISplitViewController (autoRotate)

-(BOOL)shouldAutorotate
{
    UINavigationController *vc = (UINavigationController *)[self.viewControllers objectAtIndex:1];
    return [vc.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *vc = [self.viewControllers objectAtIndex:1];
    return [vc supportedInterfaceOrientations];
}

@end
