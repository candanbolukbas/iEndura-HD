//
//  IEAppDelegate.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 14 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IEMainViewController;
@class IECameraClass;

@interface IEAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *viewController;
//@property (nonatomic, strong) NSString *encryptedUsrPassString;
@property (nonatomic, strong) NSString *userSeesionId;
@property (nonatomic, strong) NSString *navBarTitle;
@property (nonatomic, assign) BOOL dbRequiresUpdate;
@property (nonatomic, assign) BOOL favMenuOpened;
@property (nonatomic, strong) IECameraClass *currCam;


@end
