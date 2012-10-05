//
//  IESearchViewController.h
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 25 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IESearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *CamList;
    NSArray *AllCams;
}

@property (weak, nonatomic) IBOutlet UISearchBar *camerasSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *camerasListTableView;

@end
