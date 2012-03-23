//
//  MoreAppsViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/24/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "MoreAppsViewController.h"
#import "IIViewDeckController.h"

@interface MoreAppsViewController ()

@end

@implementation MoreAppsViewController

@synthesize webView;
@synthesize pendingView;

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
    
	[self.navigationItem setTitle:NSLocalizedString(@"MORE_APPS", @"")];
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    
    [webView setDelegate:self];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://atrac613.io/apps"]]];
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

#pragma mark - WebView delegate

- (void)webViewDidStartLoad:(UIWebView *)wv {
    [self showPendingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {	
    [self hidePendingView];
}

- (void)showPendingView {
    if (pendingView == nil && ![self.view.subviews containsObject:pendingView]) {
        pendingView = [[PendingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
        pendingView.titleLabel.text = NSLocalizedString(@"PLEASE_WAIT", @"Please wait");
        pendingView.userInteractionEnabled = NO;
        [self.view addSubview:pendingView];
    }
    
    [pendingView showPendingView];
}

- (void)hidePendingView {
    if ([self.view.subviews containsObject:pendingView]) {
        [pendingView hidePendingView];
        
        pendingView = nil;
    }
}

@end
