//
//  IECamListViewController.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 21 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamListViewController.h"
#import "DDBadgeViewCell.h"
#import "IECamPlayViewController.h"
#import "IEDetailViewController.h"
#import "IESettingsViewController.h"

@interface IECamListViewController ()

@end

@implementation IECamListViewController

@synthesize camListTableView, CurrentCameraLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [LocAndCamList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";
    
    // Set up the cell...
    DDBadgeViewCell *cell = (DDBadgeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.summaryColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    }
    NSObject *LocOrCam = [LocAndCamList objectAtIndex:indexPath.row];
    
    if([LocOrCam isKindOfClass:[IECameraClass class]])
    {
        IECameraClass *cc = [LocAndCamList objectAtIndex:indexPath.row];
        cell.summary = cc.Name;
        cell.detail = [NSString stringWithFormat:@"%@ - %@", cc.IP, cc.UpnpModelNumber];
        [cell HideBadge:YES];
        cell.imageView.image = [UIImage imageNamed:@"cctv.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([LocOrCam isKindOfClass:[IECameraLocation class]])
    {
        IECameraLocation *cl = [LocAndCamList objectAtIndex:indexPath.row];
        
        if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Remote)
        {
            cell.summary = cl.LocationRoot;
            cell.detail = [NSString stringWithFormat:@"%@", CurrentCameraLocation.RemoteLocation];
        }
        else if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Root)
        {
            cell.summary = cl.LocationChild;
            cell.detail = [NSString stringWithFormat:@"%@/%@", CurrentCameraLocation.RemoteLocation, cl.LocationRoot];
        }
        cell.badgeText = cl.NumberOfCameras;
        cell.badgeColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
        cell.badgeHighlightedColor = [UIColor lightGrayColor];
        
        //UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_indicator_light.png"]];
        //cell.accessoryView = accessoryViewImage;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"building.png"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *LocOrCam = [LocAndCamList objectAtIndex:indexPath.row];
    
    if([LocOrCam isKindOfClass:[IECameraClass class]])
    {
        IECameraClass *cc = [LocAndCamList objectAtIndex:indexPath.row];
        
        [APP_DELEGATE.camPlayViewController.view removeFromSuperview];  
        IECamPlayViewController *cpvc = [[IECamPlayViewController alloc] init];
            
        cpvc.CurrentCamera = cc;
        NSArray *neighborCameras = [[NSArray alloc] initWithArray:[self GetCamerasOfLocation:CurrentCameraLocation]];
        cpvc.neighborCameras = neighborCameras;
        cc.neighborCameras = [[NSArray alloc] initWithArray:[self GetCamerasOfLocation:CurrentCameraLocation]];;
    
        if (APP_DELEGATE.detailsViewController.numberOfCamImageView == 1)
        {
            APP_DELEGATE.detailsViewController.title = cc.Name;
            [APP_DELEGATE.detailsViewController.view addSubview:cpvc.view];
            APP_DELEGATE.camPlayViewController = cpvc;
            [APP_DELEGATE.detailsViewController.view setNeedsDisplay];
        }
        else
        {
            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
            CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
            APP_DELEGATE.detailsViewController.numbersScrollMenu.frame = CGRectMake(0, rectInSuperview.origin.y, 0, 60);
            [APP_DELEGATE.detailsViewController showNumbersMenuView];
            APP_DELEGATE.currCam = cc;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if([LocOrCam isKindOfClass:[IECameraLocation class]])
    {
        IECameraLocation *rl = [LocAndCamList objectAtIndex:indexPath.row];
        IECamListViewController *clvc = [[IECamListViewController alloc] init];
        IECameraLocation *cl = [[IECameraLocation alloc] init];
        cl.RemoteLocation = CurrentCameraLocation.RemoteLocation;
        if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Remote)
        {
            cl.LocationRoot = rl.LocationRoot;
            cl.LocationType = IE_Cam_Loc_Root;
            [clvc.navigationItem setTitle:cl.LocationRoot];
        }
        else if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Root)
        {
            cl.LocationRoot = rl.LocationRoot;
            cl.LocationChild = rl.LocationChild;
            cl.LocationType = IE_Cam_Loc_Child;
            [clvc.navigationItem setTitle:cl.LocationChild];
        }
        clvc.CurrentCameraLocation = cl;
        [self.navigationController pushViewController:clvc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [APP_DELEGATE.detailsViewController hideNumbersMenuView];
}

- (NSMutableArray *) GetCamerasOfLocation:(IECameraLocation *)Location
{
    NSMutableArray *cams = [[NSMutableArray alloc] init];
    
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    NSArray *neighbors = [[NSArray alloc] initWithArray:[dbOps GetItemsOfALocation:Location]];
    
    for (NSObject *locOrCam in neighbors) 
    {
        if([locOrCam isKindOfClass:[IECameraClass class]])
            [cams addObject:locOrCam];
    }
    return cams;
}

- (void) viewDidUnload 
{
    [self setCurrentCameraLocation:nil];
    LocAndCamList = nil;
    [self setCamListTableView:nil];
    [APP_DELEGATE.camPlayViewController setView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Add items
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    LocAndCamList = [dbOps GetItemsOfALocation:CurrentCameraLocation];
	self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
}

- (void)viewDidAppear:(BOOL)animated
{
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    LocAndCamList = [dbOps GetItemsOfALocation:CurrentCameraLocation];
    [camListTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end