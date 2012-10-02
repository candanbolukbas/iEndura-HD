//
//  IEDetailViewController.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 21 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEDetailViewController.h"
#import "IECamImgViewController.h"

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

- (void)singleViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    numberOfCamImageView = 1;
}

- (void)quadViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:5];
    
    for(int i=0; i<4; i++)
    {
        IECamImgViewController *civc = [[IECamImgViewController alloc] init];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/2 * (i%2), self.view.bounds.size.height/2 * (i/2), self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        civc.screenshotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%d.png", i+1]];
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
    
    [self.view bringSubviewToFront:self.numbersMenuView];
    numberOfCamImageView = 4;
}

- (void)nineViewLoad:(BOOL)show
{
    [self clearSubViewsFromDetailsView];
    
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(int i=0; i<9; i++)
    {
        IECamImgViewController *civc = [[IECamImgViewController alloc] init];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/3 * (i%3), self.view.bounds.size.height/3 * (i/3), self.view.bounds.size.width/3, self.view.bounds.size.height/3);
        civc.screenshotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%d.png", i+1]];
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
    
    [self.view bringSubviewToFront:self.numbersMenuView];
    numberOfCamImageView = 9;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];

    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
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
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *viewButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = viewButtons;
    
    self.numbersScrollMenu.contentSize = CGSizeMake(700, 60);
    numberOfCamImageView = 1;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{

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
    double x = self.numbersScrollMenu.frame.origin.x;
    double y = self.numbersScrollMenu.frame.origin.y;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.numbersScrollMenu setFrame:CGRectMake(x, y, 450, 60)];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             [self.numbersScrollMenu setFrame:CGRectMake(x, y, 380, 60)];
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 animations:^{
                                 [self.numbersScrollMenu setFrame:CGRectMake(x, y, 400, 60)];;
                             }];
                         }];
                     }];
}

- (void) hideNumbersMenuView
{
    [UIView animateWithDuration:(0.3)
                     animations:^{
                         [self.numbersMenuView setAlpha:0.0f];
                     }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (IBAction)numbersMenuButtonClicked:(UIButton *)sender
{
    [self hideNumbersMenuView];
    IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:sender.tag-101];
    civc.CurrentCamera = APP_DELEGATE.currCam;
    civc.fullScreen = NO;
    civc.selectedImageViewIndex = sender.tag-101;
    [civc.screenshotImageView setBackgroundColor:[UIColor blackColor]];
}
@end




