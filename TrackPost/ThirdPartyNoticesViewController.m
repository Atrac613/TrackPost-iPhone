//
//  ThirdPartyNoticesViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "ThirdPartyNoticesViewController.h"
#import "IIViewDeckController.h"

@interface ThirdPartyNoticesViewController ()

@end

@implementation ThirdPartyNoticesViewController

@synthesize webView;

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
    
    [self.navigationItem setTitle:NSLocalizedString(@"LICENSE", @"")];
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    
	[webView setDelegate:self];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"third_party_notices" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
