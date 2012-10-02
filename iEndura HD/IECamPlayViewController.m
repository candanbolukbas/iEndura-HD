//
//  IECamViewController.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 21 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IECamImgViewController.h"
#import "IEDetailViewController.h"

@interface IECamPlayViewController ()

@end

@implementation IECamPlayViewController
@synthesize overlayView, nextCamLabel, playCamLabel, prevCamLabel, nextButton, prevButton, neighborCameras;
@synthesize CurrentCamera, testLabel, screenshotImageView, addToFavoritesButton, playScrollView;
@synthesize alertBoxBGImageView, alertBoxIconImageView, alertBoxDescLabel, videoWebView;
@synthesize imageTimer, dismissButton, playSmoothButton, playSmoothTimer, serverDefineView, showDismissButton;

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag withObject:(NSObject *)additionalParameters 
{
	if (tag == IE_Req_CamImage)  
    {
        IECameraClass *cc = [[IECameraClass alloc] init];
        cc = (IECameraClass *)additionalParameters;
        if([cc.Name isEqualToString:CurrentCamera.Name] && [cc.IP isEqualToString:CurrentCamera.IP])
        {
            NSString *base64EncodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *imgData = [[NSData alloc] initWithBase64EncodedString:base64EncodedString];
            UIImage *ret = [UIImage imageWithData:imgData];
            screenshotImageView.image = ret;
        }
        connnectionReady = YES;
    }
    else if (tag == IE_Req_CamHls) 
    {
        
        IECameraClass *cc = [[IECameraClass alloc] init];
        cc = (IECameraClass *)additionalParameters;
        if([cc.Name isEqualToString:CurrentCamera.Name] && [cc.IP isEqualToString:CurrentCamera.IP])
        {
            NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:data];
            SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
            
            if([sc.Id isEqualToString:POZITIVE_VALUE])
            {
//                if(civc && civc != nil)
//                    [civc dismissModalViewControllerAnimated:YES];
                NSURL *streamUrl = [[NSURL alloc] initWithString:sc.Value];
                [playSmoothTimer invalidate];
                [playSmoothButton setEnabled:YES];
                playSmoothCounter = 30;
                NSLog(@"%@", streamUrl);
                [videoWebView setHidden:NO];
                [imageTimer invalidate];
                [videoWebView loadRequest:[NSURLRequest requestWithURL:streamUrl]];
            }
            else 
            {
                [playSmoothTimer invalidate];
                [playSmoothButton setEnabled:YES];
                playSmoothCounter = 30;
                testLabel.text = sc.Value;
            }
        }
    }
	else if (tag == IE_Req_Auth)
    {
        NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:data];
        SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
        if ([sc.Id isEqualToString:POZITIVE_VALUE]) 
        {
            APP_DELEGATE.userSeesionId = sc.Value;
            [self hideUpdateView];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)SetPlayButtons
{
    int neighborCount = neighborCameras.count;
    if(neighborCount > 0)
    {
        int camIndex = [self FindIndexOfCamera:CurrentCamera InArray:neighborCameras];
        if (camIndex != -1) 
        {
            if (camIndex == 0) 
            {
                [prevButton setEnabled:NO];
                [prevCamLabel setText:@""];
            }
            else 
            {
                [prevButton setEnabled:YES];
                IECameraClass *prevCam = [[IECameraClass alloc] init];
                prevCam = [neighborCameras objectAtIndex:camIndex-1];
                [prevCamLabel setText:prevCam.Name];
            }
            if (camIndex == neighborCount - 1) 
            {
                [nextButton setEnabled:NO];
                [nextCamLabel setText:@""];
            }
            else 
            {
                [nextButton setEnabled:YES];
                IECameraClass *nextCam = [[IECameraClass alloc] init];
                nextCam = [neighborCameras objectAtIndex:camIndex+1];
                [nextCamLabel setText:nextCam.Name];
            }
        }
    }
    else 
    {
        [prevButton setEnabled:NO];
        [prevCamLabel setText:@""];
        [nextButton setEnabled:NO];
        [nextCamLabel setText:@""];
    }
}

- (void)SetFavoriteButton
{
    NSArray *currentFovorites = [IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY];
    if([currentFovorites containsObject:CurrentCamera.IP])
    {
        UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav.png"];
        [addToFavoritesButton setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav_disabled.png"];
        [addToFavoritesButton setImage:btnImage forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *oneFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchAction)];
	[oneFingerDoubleTap setNumberOfTapsRequired:1];
	[oneFingerDoubleTap setNumberOfTouchesRequired:1];
    [screenshotImageView addGestureRecognizer:oneFingerDoubleTap];
	
    if (showDismissButton) 
    {
        [self.dismissButton setHidden:NO];
    }
    
    [self SetFavoriteButton];
    [self SetPlayButtons];
}

- (void)SetScreenShotImage
{
    testLabel.text = CurrentCamera.Name;
    if(CurrentCamera.uuid.length > 0)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        connnectionReady = YES;
        imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
    }
    else 
    {
        screenshotImageView.image = [UIImage imageNamed:@"no_preview.png"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(APP_DELEGATE.currCam != nil)
    {
        CurrentCamera = APP_DELEGATE.currCam;
        APP_DELEGATE.currCam = nil;
    }
    
    if([APP_DELEGATE.userSeesionId isEqualToString:@""])
    {
        [self GetSessionId];
    }
    else 
    {
        [self ResetObjects];
    }
}

- (void)viewDidUnload
{
    [self setTestLabel:nil];
    [self setScreenshotImageView:nil];
    [self setVideoWebView:nil];
    [self setImageTimer:nil];
    [self setAddToFavoritesButton:nil];
    [self setPlayScrollView:nil];
    [self setAlertBoxBGImageView:nil];
    [self setAlertBoxIconImageView:nil];
    [self setAlertBoxDescLabel:nil];
    [self setDismissButton:nil];
    [self setPlaySmoothButton:nil];
    [self setNextButton:nil];
    [self setPrevButton:nil];
    [self setNextCamLabel:nil];
    [self setPlayCamLabel:nil];
    [self setPrevCamLabel:nil];
    [self setOverlayView:nil];
    CurrentCamera = nil;
    neighborCameras = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [imageTimer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        playScrollView.contentSize = CGSizeMake(320, 370);
    }
    else 
    {
        playScrollView.contentSize = CGSizeMake(320, 370);
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (void)UpdateImage:(NSTimer *)theTimer 
{
    NSURL *camImgUrl = [IEServiceManager GetCamImgUrl:CurrentCamera.IP];
    if(connnectionReady)
    {
        IEConnController *controller = [[IEConnController alloc] initWithURL:camImgUrl property:IE_Req_CamImage];
        controller.delegate = self;
        controller.addParams = CurrentCamera;
        [controller startConnection];
        connnectionReady = NO;
    }
}

- (void)GetSessionId
{
    NSURL *authUrl = [IEServiceManager GetAuthenticationUrlFromUsrPass];
    [self showUpdateView];
    IEConnController *controller = [[IEConnController alloc] initWithURL:authUrl property:IE_Req_Auth];
    controller.delegate = self;
    [controller startConnection];
}

- (void)UpdatePlaySmoothCounter:(NSTimer *)theTimer
{
    if(playSmoothCounter < 0)
    {
        [playSmoothButton setEnabled:YES];
        testLabel.text = @"Can't connect to iEndura server.";
    }
    else
    {
        testLabel.text = [NSString stringWithFormat:@"The smooth stream will be ready in %d secs.", playSmoothCounter--];
        //[playSmoothButton setTitle:[NSString stringWithFormat:@"The stream will be ready in %d secs.", playSmoothCounter--] forState:UIControlStateDisabled];
    }
}

- (IBAction)playButtonClicked:(UIButton *)sender 
{
    NSURL *camHlsReqUrl = [IEServiceManager GetCamHlsReqUrl:CurrentCamera.IP];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camHlsReqUrl property:IE_Req_CamHls];
	controller.delegate = self;
    controller.addParams = CurrentCamera;
	[controller startConnection];
    
    playSmoothCounter = 30;
    [playSmoothButton setEnabled:NO];
    [playSmoothTimer invalidate];
    [self setPlaySmoothTimer:nil];
    testLabel.text = [NSString stringWithFormat:@"The smooth stream will be ready in %d secs.", playSmoothCounter--];
    playSmoothTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(UpdatePlaySmoothCounter:) userInfo:nil repeats:YES];
}

- (void) ResetObjects
{        
    //[imageTimer invalidate];
    //[self setImageTimer:nil];
    //[playSmoothTimer invalidate];
    //[self  setPlaySmoothTimer:nil];
    playSmoothCounter = 30;
    [playSmoothButton setEnabled:YES];
    screenshotImageView.image = [UIImage imageNamed:@"connecting.png"];
    APP_DELEGATE.detailsViewController.title = CurrentCamera.Name;
    [self SetFavoriteButton];
    [self SetPlayButtons];
    [self SetScreenShotImage];
}

- (int) FindIndexOfCamera:(IECameraClass *)cam InArray:(NSArray *)camArray
{
    for (int i=0; i < camArray.count; i++) 
    {
        IECameraClass *cc = [[IECameraClass alloc] init];
        cc = [camArray objectAtIndex:i];
        if([cc.Name isEqualToString:cam.Name] && [cc.IP isEqualToString:cam.IP ])
        {
            return i;
        }
    }
    return -1;
}

- (IBAction)swipeLeftImageView
{
    [self nextButtonClicked:nil];
}
- (IBAction)swipeRightImageView
{
    [self prevButtonClicked:nil];
}

- (IBAction)prevButtonClicked:(UIButton *)sender 
{
    //[self showUpdateView];
    int camIndex = [self FindIndexOfCamera:CurrentCamera InArray:neighborCameras];
    
    if (camIndex != -1 && camIndex != 0) 
    {
        IECameraClass *prevCam = [[IECameraClass alloc] init];
        prevCam = [neighborCameras objectAtIndex:camIndex-1];
        CurrentCamera = prevCam;
        
        [self ResetObjects];
    }
    //[self hideUpdateView];
}

- (IBAction)nextButtonClicked:(UIButton *)sender 
{
    //[self showUpdateView];
    int camIndex = [self FindIndexOfCamera:CurrentCamera InArray:neighborCameras];
    
    if (camIndex != -1 && camIndex != neighborCameras.count-1) 
    {
        IECameraClass *nextCam = [[IECameraClass alloc] init];
        nextCam = [neighborCameras objectAtIndex:camIndex+1];
        CurrentCamera = nextCam;
        
        [self ResetObjects];
    }
    //[self hideUpdateView];
}

- (void)dismissAlertWindow
{
    alertBoxBGImageView.alpha = 0.0;
    alertBoxDescLabel.alpha = 0.0;
    alertBoxIconImageView.alpha = 0.0;
}

- (void)showAlertWindow
{
    alertBoxBGImageView.alpha = 0.6;
    alertBoxDescLabel.alpha = 1.0;
    alertBoxIconImageView.alpha = 1.0;
}

- (void)animateAlertBox:(UIImage *)alertIconImage :(NSString *)alertDesc 
{
    alertBoxIconImageView.image = alertIconImage;
    alertBoxDescLabel.text = alertDesc;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [self showAlertWindow];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8/2 animations:^{
            alertBoxBGImageView.alpha = 0.61;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2/2 animations:^{
                [self dismissAlertWindow];
            }];
        }];
    }];
}

- (IBAction)addToFavoritesButtonClicked:(UIButton *)sender 
{
    NSMutableArray *currentFovorites = [[NSMutableArray alloc] initWithArray:[IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY] copyItems:YES];
    if(currentFovorites)
    {
        if([currentFovorites containsObject:CurrentCamera.IP])
        {
            [currentFovorites removeObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                UIImage *alertIconImage = [UIImage imageNamed:@"balloon_fav_disabled.png"];
                [self animateAlertBox:alertIconImage :@"Removed from your favorites"];
                UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav_disabled.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not remove from favorites.");
            }
        }
        else 
        {
            [currentFovorites addObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                UIImage *alertIconImage = [UIImage imageNamed:@"balloon_fav_enabled.png"];
                [self animateAlertBox:alertIconImage :@"Added to your favorites"];
                UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not added to favorites.");
            }
        }
    }
    else {
        NSLog(@"Cant get current favorite cams");
    }
}

- (IBAction)dismissButtonClicked:(id)sender 
{
    [dismissButton setHidden:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)imageViewTouchAction 
{
    civc = [[IECamImgViewController alloc] init];
    civc.CurrentCamera = CurrentCamera;
    civc.neighborCameras = neighborCameras;
    civc.fullScreen = YES;
    [APP_DELEGATE.splitViewController presentModalViewController:civc animated:YES];
    [civc.screenshotImageView setBackgroundColor:[UIColor blackColor]];
}


- (void) showUpdateView
{
    //[overlayView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0f]];
    [overlayView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [overlayView setAlpha:0.9f];
                     }];
}

- (void) hideUpdateView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [overlayView setAlpha:0.0f];
                     }];
}


@end

