//
//  ScrobblerViewController.m
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import "ScrobblerViewController.h"
#import "TrackPostAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LastFMService.h"

@implementation ScrobblerViewController

@synthesize artistNameLabel;
@synthesize trackNameLabel;
//@synthesize refreshButton;
@synthesize scrobblerButton;
@synthesize loveButton;
@synthesize bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    
    UIView *titleView = [[[UIView alloc] init] autorelease];
    [titleView setFrame:CGRectMake(0, 0, 140, 44)];
    
    UILabel *appNameView = [[[UILabel alloc] init] autorelease];
    [appNameView setFrame:CGRectMake(0, 0, 140, 28)];
    [appNameView setText:@"Scrobbler"];
    [appNameView setFont:[UIFont systemFontOfSize:17]];
    [appNameView setBackgroundColor:[UIColor clearColor]];
    [appNameView setTextColor:[UIColor whiteColor]];
    [appNameView setTextAlignment:UITextAlignmentCenter];
    [appNameView setAdjustsFontSizeToFitWidth:YES];
    [titleView addSubview:appNameView];
    
    UILabel *titleSubView = [[[UILabel alloc] init] autorelease];
    [titleSubView setFrame:CGRectMake(0, 23, 140, 13)];
    [titleSubView setText:[NSString stringWithFormat:@"from %@", username]];
    [titleSubView setFont:[UIFont systemFontOfSize:13]];
    [titleSubView setBackgroundColor:[UIColor clearColor]];
    [titleSubView setTextColor:[UIColor whiteColor]];
    [titleSubView setTextAlignment:UITextAlignmentCenter];
    [titleSubView setAdjustsFontSizeToFitWidth:YES];
    [titleView addSubview:titleSubView];
    
    self.navigationItem.titleView = titleView;
    
    self.bannerIsVisible = NO;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonPressed:)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Logout", @"Logout")]){
		[self performSelectorOnMainThread:@selector(logoutAction) withObject:nil waitUntilDone:YES];
    }
}

- (void)logoutAction {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_user"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_session"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[LastFMService sharedInstance].session = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)logoutButtonPressed:(id)sender {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGOUT_TITLE", @"Logout confirmation title")
                                                     message:NSLocalizedString(@"LOGOUT_BODY",@"Logout confirmation")
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel")
                                           otherButtonTitles:NSLocalizedString(@"Logout", @"Logout"), nil] autorelease];
	[alert show];
}

- (IBAction)refreshButtonPressed:(id)sender {
    NSLog(@"Refresh Button Pressed.");
    
    MPMusicPlayerController *iPodController = [MPMusicPlayerController iPodMusicPlayer];
    
    float time = [iPodController currentPlaybackTime];
    int isPlaying = [iPodController playbackState];
    
    NSString *title	= [[iPodController nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist	= [[iPodController nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist];
    
    [artistNameLabel setText:artist];
    [trackNameLabel setText:title];
    
    NSLog(@"Time: %f", time);
    NSLog(@"Play State: %d", isPlaying);
    
    if (isPlaying == MPMusicPlaybackStatePlaying) {
        NSLog(@"Playing...");
    }
}

- (IBAction)scrobblerButtonPressed:(id)sender {
    NSLog(@"Scrobbler Button Pressed.");
    
    [scrobblerButton setEnabled:NO];
    [scrobblerButton setAlpha:0.5f];
    
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeScrobblerAction) object:nil] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
}

- (IBAction)loveButtonPressed:(id)sender {
    NSLog(@"Love Button Pressed.");
    
    [loveButton setEnabled:NO];
    [loveButton setAlpha:0.5f];
    
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoveAction) object:nil] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
    
}

- (void)synchronizeScrobblerAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;
    NSLog(@"session: %@", session);
    
    [service nowPlayingTrack:trackNameLabel.text byArtist:artistNameLabel.text onAlbum:@"" withDuration:1];
    
    NSLog(@"code %d", [service.error code]);
    NSLog(@"domain %@", [service.error domain]);
    NSLog(@"desc %@", [service.error localizedDescription]);
	
	[self performSelectorOnMainThread:@selector(completeScrobblerAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeScrobblerAction:(NSError*)error {
    NSLog(@"Post Success");
    
    [scrobblerButton setEnabled:YES];
    [scrobblerButton setAlpha:1];
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    UIAlertView *alert;
    if ([error code]) {
        alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"POST_ERROR_TITLE", @"Post successful title")
                                            message:NSLocalizedString([error localizedDescription], @"error")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil] autorelease];
    } else {
        alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"POST_SUCCESS_TITLE", @"Post successful title")
                                            message:NSLocalizedString(@"POST_SUCCESS_BODY",@"Post Successfull")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil] autorelease];
    }
    
	[alert show];
}


- (void)synchronizeLoveAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;
    NSLog(@"session: %@", session);
    
    [service loveTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    
    NSLog(@"%d", [LastFMService sharedInstance].error.code);
    NSLog(@"%@", [LastFMService sharedInstance].error.domain);
	
	[self performSelectorOnMainThread:@selector(completeLoveAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeLoveAction:(NSError*)error {
    NSLog(@"Love Success");
    
    [loveButton setEnabled:YES];
    [loveButton setAlpha:1];
    
    UIAlertView *alert;
    if ([error code]) {
        alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOVE_ERROR_TITLE", @"Love successful title")
                                            message:NSLocalizedString([error localizedDescription], @"error")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil] autorelease];
    } else {
        alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOVE_SUCCESS_TITLE", @"Love successful title")
                                            message:NSLocalizedString(@"LOVE_SUCCESS_BODY",@"Love Successfull")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil] autorelease];
    }
	[alert show];
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

@end
