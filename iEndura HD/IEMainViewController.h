//
//  IEMainViewController.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 14 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//


@interface IEMainViewController : IEBaseViewController <IEConnControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *remoteLocations;
    int camListConnectionCounter;
    NSTimer *camListTimer;
    int timeOutCamList;
}

@property (weak, nonatomic) IBOutlet UITableView *remoteLocationsTableView;
@property (weak, nonatomic) IBOutlet UILabel *updateRsultLabel;

@end
