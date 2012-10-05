//
//  IEDetailViewController.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 21 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEDetailViewController.h"
#import "IECamImgViewController.h"
#import "IEEmptyViewController.h"
#import "IECamPlayViewController.h" 

@interface IEDetailViewController ()

@end

@implementation IEDetailViewController
@synthesize popoverController, numberOfCamImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)clearSubViewsFromDetailsView
{
    for (IECamImgViewController *civc in subImageViews)
    {
        [civc.view removeFromSuperview];
        [civc removeFromParentViewController];
    }
}

- (void)fullViewLoad:(BOOL)show
{
    if(self.popoverController != nil)
        return;
    
    if(numberOfCamImageView == 1)
    {
        if (APP_DELEGATE.camPlayViewController != nil)
        {
            IECamImgViewController *cpvc = (IECamImgViewController *)APP_DELEGATE.camPlayViewController;
            [cpvc imageViewTouchAction];
        }
    }
    else
    {
        IEEmptyViewController *evc = [[IEEmptyViewController alloc] init];
        evc.subImageViews = [[NSArray alloc] initWithArray:subImageViews];
        evc.numberOfCamImageView = numberOfCamImageView;
        [self presentModalViewController:evc animated:YES];
    }
}

- (void)singleViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    [self resetObjectsWithNumber:1];
    if(APP_DELEGATE.camPlayViewController != nil)
    {
        [APP_DELEGATE.camPlayViewController.view removeFromSuperview];
        self.title = APP_DELEGATE.camPlayViewController.CurrentCamera.Name;
        [self.view addSubview:APP_DELEGATE.camPlayViewController.view];
    }
    else
        self.title = @"No Camera Selected";
}

- (void)quadViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:5];
    self.title = @"4-view";
    
    for(int i=0; i<4; i++)
    {
        IECamImgViewController *civc = [[IECamImgViewController alloc] init];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/2 * (i%2), self.view.bounds.size.height/2 * (i/2), self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        civc.screenshotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%d.png", i+1]];
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
    
    [self resetObjectsWithNumber:4];
}

- (void)nineViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:10];
    self.title = @"9-view";
    
    for(int i=0; i<9; i++)
    {
        IECamImgViewController *civc = [[IECamImgViewController alloc] init];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/3 * (i%3), self.view.bounds.size.height/3 * (i/3), self.view.bounds.size.width/3, self.view.bounds.size.height/3);
        civc.screenshotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%d.png", i+1]];
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
    
    [self resetObjectsWithNumber:9];
}

- (void)resetObjectsWithNumber:(int)viewCount
{
    [self.view bringSubviewToFront:self.numbersMenuView];
    numberOfCamImageView = viewCount;
    [self hideNumbersMenuView];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];

    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.barStyle = -1; // clear background
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"single_view_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(singleViewLoad:)];
    bbi.width = 30.0f;
    [buttons addObject:bbi];
    
    bbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quad_view_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(quadViewLoad:)];
    bbi.width = 30.0f;
    [buttons addObject:bbi];
    
    bbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nine_view_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nineViewLoad:)];
    bbi.width = 30.0f;
    [buttons addObject:bbi];
    
    bbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"full_view_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fullViewLoad:)];
    bbi.width = 30.0f;
    bbi.tag = 199;
    [buttons addObject:bbi];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *viewButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = viewButtons;
    
    numberOfCamImageView = 1;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)resetnumbersScroolMenu
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.numbersScrollMenu setFrame:CGRectMake(0, self.numbersScrollMenu.frame.origin.y, 1, 60)];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             [self.numbersScrollMenu setFrame:CGRectMake(0, self.numbersScrollMenu.frame.origin.y, 0, 60)];
                         }];
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(numberOfCamImageView > 1)
    {
        [self clearSubViewsFromDetailsView];
        for (IECamImgViewController *civc in subImageViews)
        {
            [self.view addSubview:civc.view];
        }
    }
    
    [self shouldAutorotateToInterfaceOrientation:[[UIDevice currentDevice] orientation]];
    [self resetnumbersScroolMenu];
}

- (void)viewDidUnload
{
    [self setPopoverController:nil];
    [self setNumbersScrollMenu:nil];
    [self setNumbersMenuView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem  forPopoverController: (UIPopoverController*)pc 
{
    barButtonItem.title = @"iEndura";
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.popoverController = pc;
    self.popoverController.delegate = self;
    self.popoverController.passthroughViews = [[NSArray alloc] initWithObjects:self.numbersScrollMenu, self.numbersMenuView, nil];
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
    [items removeAllObjects];
    [self.navigationItem setLeftBarButtonItems:items animated:YES];
    self.popoverController = nil;   
}

- (void) showNumbersMenuView
{
    [self.numbersMenuView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.numbersScrollMenu setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    [self.numbersMenuView setAlpha:1.0f];
    double x = (self.popoverController == nil) ? 0 : 320;
    //double x = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ? 0 : 320;
    //double x = self.numbersScrollMenu.frame.origin.x;
    double y = self.numbersScrollMenu.frame.origin.y;
    self.numbersScrollMenu.contentSize = CGSizeMake(68 * numberOfCamImageView, 60);
    double width = numberOfCamImageView > 5 ? 400 : 68 * numberOfCamImageView;
    
    for (int i=0; i<9; i++)
    {
        UIButton *bt = (UIButton *)[self.view viewWithTag:101+i];
        if(i < numberOfCamImageView)
            [bt setHidden:NO];
        else
            [bt setHidden:YES];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.numbersScrollMenu setFrame:CGRectMake(x, y, width + 30, 60)];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             [self.numbersScrollMenu setFrame:CGRectMake(x, y, width - 20, 60)];
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 animations:^{
                                 [self.numbersScrollMenu setFrame:CGRectMake(x, y, width, 60)];
                             }];
                         }];
                     }];
    [self.view bringSubviewToFront:self.numbersScrollMenu];
}

- (void) hideNumbersMenuView
{
    [UIView animateWithDuration:(0.3)
                     animations:^{
                         [self.numbersMenuView setAlpha:0.0f];
                         [self.numbersScrollMenu setFrame:CGRectMake(0, self.numbersScrollMenu.frame.origin.y, 0, 60)];
                     }];
    [self.view bringSubviewToFront:self.numbersMenuView];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self hideNumbersMenuView];
    return YES;
}

- (IBAction)numbersMenuButtonClicked:(UIButton *)sender
{
    [self hideNumbersMenuView];
    IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:sender.tag-101];
    civc.CurrentCamera = APP_DELEGATE.currCam;
    civc.fullScreen = NO;
    civc.selectedImageViewIndex = sender.tag-101;
    civc.camNameLabel.text = civc.CurrentCamera.Name;
    civc.neighborCameras = [[NSArray alloc] initWithArray:APP_DELEGATE.currCam.neighborCameras];
    [civc.screenshotImageView setBackgroundColor:[UIColor blackColor]];
}

- (IBAction)numbersMenuBackgroungTouchAction:(id)sender
{
    [self hideNumbersMenuView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(numberOfCamImageView ==1)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            APP_DELEGATE.camPlayViewController.view.frame = CGRectMake(32, 0, 703, 748);
        }
        else
            APP_DELEGATE.camPlayViewController.view.frame = CGRectMake(0, 0, 703, 748);

    }
    else if(numberOfCamImageView == 4)
    {
        for(int i=0; i<4; i++)
        {
            IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
            civc.view.frame = CGRectMake(self.view.bounds.size.width/2 * (i%2), self.view.bounds.size.height/2 * (i/2), self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }
    }
    else if(numberOfCamImageView == 9)
    {
        for(int i=0; i<9; i++)
        {
            IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
            civc.view.frame = CGRectMake(self.view.bounds.size.width/3 * (i%3), self.view.bounds.size.height/3 * (i/3), self.view.bounds.size.width/3, self.view.bounds.size.height/3);
        }
    }
    [self hideNumbersMenuView];
    
	return YES;
}

- (BOOL)shouldAutorotate
{
    [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end




