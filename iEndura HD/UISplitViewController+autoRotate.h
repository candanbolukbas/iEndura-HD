//
//  UISplitViewController+autoRotate.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 2 Oct.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISplitViewController (autoRotate)

-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
