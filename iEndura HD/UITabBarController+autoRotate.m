//
//  UITabBarController+autoRotate.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 2 Oct.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "UITabBarController+autoRotate.h"

@implementation UITabBarController (autoRotate)

-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
