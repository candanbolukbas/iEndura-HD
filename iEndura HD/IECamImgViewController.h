//
//  IECamImgViewController.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 25 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IECamImgViewController : UIViewController <IEConnControllerDelegate>
{
    IECameraClass *CurrentCamera;
    NSArray *neighborCameras;
    NSTimer *imageTimer;
    BOOL connectionReady;
}

@property (nonatomic,retain) IECameraClass *CurrentCamera;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (nonatomic,retain) NSArray *neighborCameras;
@property (nonatomic, retain) NSTimer *imageTimer;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, assign) BOOL fullScreen;
@property (nonatomic,assign) int selectedImageViewIndex;

- (IBAction)imageViewTouchAction;
- (IBAction)imageSwipeLeftAction;
- (IBAction)imageSwipeRightAction;

@end
