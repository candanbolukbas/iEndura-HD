//
//  IEEmptyViewController.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 3 Oct.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEEmptyViewController.h"
#import "IECamImgViewController.h"

@interface IEEmptyViewController ()

@end

@implementation IEEmptyViewController

@synthesize numberOfCamImageView, subImageViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(numberOfCamImageView == 4)
        [self quadViewLoad:YES];
    else if(numberOfCamImageView == 9)
        [self nineViewLoad:YES];
    
    [self.view layoutSubviews];
    [self.view bringSubviewToFront:self.closeButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearSubViewsFromDetailsView
{
    for (IECamImgViewController *civc in subImageViews)
    {
        [civc.view removeFromSuperview];
        [civc removeFromParentViewController];
    }
}

- (void)quadViewLoad:(BOOL)show
{
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:5];
    
    for(int i=0; i<4; i++)
    {
        IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/2 * (i%2), self.view.bounds.size.height/2 * (i/2), self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
}

- (void)nineViewLoad:(BOOL)show
{
    NSMutableArray *mutSubViews = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(int i=0; i<9; i++)
    {
        IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
        civc.view.frame = CGRectMake(self.view.bounds.size.width/3 * (i%3), self.view.bounds.size.height/3 * (i/3), self.view.bounds.size.width/3, self.view.bounds.size.height/3);
        civc.screenshotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"number-%d.png", i+1]];
        [mutSubViews addObject:civc];
        [self.view addSubview:civc.view];
    }
    subImageViews = [[NSArray alloc] initWithArray:mutSubViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(numberOfCamImageView == 4)
    {
        for(int i=0; i<4; i++)
        {
            IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
            civc.view.frame = CGRectMake(self.view.bounds.size.width/2 * (i%2), self.view.bounds.size.height/2 * (i/2), self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }
    }
    else
    {
        for(int i=0; i<9; i++)
        {
            IECamImgViewController *civc = (IECamImgViewController *)[subImageViews objectAtIndex:i];
            civc.view.frame = CGRectMake(self.view.bounds.size.width/3 * (i%3), self.view.bounds.size.height/3 * (i/3), self.view.bounds.size.width/3, self.view.bounds.size.height/3);
        }
    }
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

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [super viewDidUnload];
}
- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
