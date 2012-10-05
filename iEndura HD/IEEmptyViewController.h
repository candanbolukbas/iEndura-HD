//
//  IEEmptyViewController.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 3 Oct.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEEmptyViewController : UIViewController

@property (nonatomic,assign) int numberOfCamImageView;
@property (nonatomic,retain) NSArray *subImageViews;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeButtonClicked:(id)sender;

@end
