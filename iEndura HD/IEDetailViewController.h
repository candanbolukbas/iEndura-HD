//
//  IEDetailViewController.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 21 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,  UINavigationControllerDelegate, UITabBarControllerDelegate>
{
    NSArray *subImageViews;
}


@property (nonatomic,assign) int numberOfCamImageView;
@property (weak, nonatomic) IBOutlet UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UIScrollView *numbersScrollMenu;
@property (weak, nonatomic) IBOutlet UIView *numbersMenuView;

- (IBAction)numbersMenuButtonClicked:(UIButton *)sender;
- (void) showNumbersMenuView;
- (void) hideNumbersMenuView;
- (IBAction)numbersMenuBackgroungTouchAction:(id)sender;

@end
