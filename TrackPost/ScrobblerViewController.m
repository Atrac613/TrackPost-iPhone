//
//  ScrobblerViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/17/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "ScrobblerViewController.h"
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+MD5.h"
#import "ShareViewController.h"

@interface ScrobblerViewController ()

@end

@implementation ScrobblerViewController

@synthesize artistNameLabel;
@synthesize trackNameLabel;
@synthesize waitingForiPodLabel;
@synthesize tagsLabel;
@synthesize shareButton;
@synthesize scrobbleButton;
@synthesize loveButton;
@synthesize bannerIsVisible;
@synthesize lastfmPage;
@synthesize isPlaying;
@synthesize tagTextView;
@synthesize tagArray;
@synthesize trackInfo;
@synthesize trackImageView;
@synthesize lovedTrack;
@synthesize adView;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:LASTFM_KEY_USER];
    
    UIView *titleView = [[UIView alloc] init];
    [titleView setFrame:CGRectMake(0, 0, 140, 44)];
    
    UILabel *appNameView = [[UILabel alloc] init];
    [appNameView setFrame:CGRectMake(0, 0, 140, 28)];
    [appNameView setText:@"TrackPost"];
    [appNameView setFont:[UIFont systemFontOfSize:17]];
    [appNameView setBackgroundColor:[UIColor clearColor]];
    [appNameView setTextColor:[UIColor whiteColor]];
    [appNameView setTextAlignment:UITextAlignmentCenter];
    [appNameView setAdjustsFontSizeToFitWidth:YES];
    [titleView addSubview:appNameView];
    
    UILabel *titleSubView = [[UILabel alloc] init];
    [titleSubView setFrame:CGRectMake(0, 26, 140, 13)];
    [titleSubView setText:[NSString stringWithFormat:@"from %@", username]];
    [titleSubView setFont:[UIFont systemFontOfSize:13]];
    [titleSubView setBackgroundColor:[UIColor clearColor]];
    [titleSubView setTextColor:[UIColor whiteColor]];
    [titleSubView setTextAlignment:UITextAlignmentCenter];
    [titleSubView setAdjustsFontSizeToFitWidth:YES];
    [titleView addSubview:titleSubView];
    
    self.navigationItem.titleView = titleView;
    
    self.bannerIsVisible = NO;
    adView.frame = CGRectOffset(adView.frame, 0, 50);
    
    self.lovedTrack = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshCurrentTracks)];
    
    self.trackImageView.backgroundColor = [UIColor lightGrayColor];
    self.trackImageView.alpha = 0.5f;
    self.trackImageView.layer.cornerRadius = 10.f;
    self.trackImageView.clipsToBounds = YES;
    
    [tagsLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"TAGS", @"")]];
    [waitingForiPodLabel setText:NSLocalizedString(@"WAITING_FOR_PLAYING", @"")];
    [scrobbleButton setTitle:NSLocalizedString(@"SCROBBLE", @"") forState:UIControlStateNormal];
    [shareButton setTitle:NSLocalizedString(@"SHARE", @"") forState:UIControlStateNormal];
    [loveButton setTitle:NSLocalizedString(@"LOVE", @"") forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    
    adView.delegate = self;
    
    [self refreshCurrentTracks];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    adView.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1){
		[self performSelectorOnMainThread:@selector(logoutAction) withObject:nil waitUntilDone:YES];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"shareButtonPressed");
    
    ShareViewController *shareViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    shareViewController.artistName = artistNameLabel.text;
    shareViewController.trackName = trackNameLabel.text;
    shareViewController.lastfmPage = lastfmPage;
    [self presentModalViewController:shareViewController animated:YES];
}

- (void)refreshCurrentTracks {
    MPMusicPlayerController *iPodController = [MPMusicPlayerController iPodMusicPlayer];
    
    float time = [iPodController currentPlaybackTime];
    isPlaying = [iPodController playbackState];
    
    if (isPlaying) {
        NSString *title	= [[iPodController nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist = [[iPodController nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist];
        
        [artistNameLabel setText:artist];
        [trackNameLabel setText:title];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTrackInfoAction) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [SharedAppDelegate.operationQueue addOperation:operation];
        
        [artistNameLabel setHidden:NO];
        [trackNameLabel setHidden:NO];
        [waitingForiPodLabel setHidden:YES];
        
        [scrobbleButton setEnabled:YES];
        [scrobbleButton setAlpha:1];
        
        [loveButton setEnabled:YES];
        [loveButton setAlpha:1];
    } else {
        [artistNameLabel setHidden:YES];
        [trackNameLabel setHidden:YES];
        [waitingForiPodLabel setHidden:NO];
        
        [scrobbleButton setEnabled:NO];
        [scrobbleButton setAlpha:0.5f];
        
        [loveButton setEnabled:NO];
        [loveButton setAlpha:0.5f];
        
        [shareButton setEnabled:NO];
        [shareButton setAlpha:0.5f];
    }
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"Time: %f", time);
    NSLog(@"Play State: %d", isPlaying);
    NSLog(@"Time: %ld", unixTime);
    
    if (isPlaying == MPMusicPlaybackStatePlaying) {
        NSLog(@"Playing...");
    }
}

- (IBAction)scrobbleButtonPressed:(id)sender {
    NSLog(@"scrobbleButtonPressed");
    
    if (isPlaying) {
        [scrobbleButton setEnabled:NO];
        [scrobbleButton setAlpha:0.5f];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeScrobbleAction) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [SharedAppDelegate.operationQueue addOperation:operation];
    }
}

- (IBAction)loveButtonPressed:(id)sender {
    NSLog(@"loveButtonPressed.");
    NSLog(@"trackInfo: %@", self.trackInfo);
    
    if (isPlaying) {
        if (lovedTrack) {
            lovedTrack = NO;
        } else {
            lovedTrack = YES;
        }
        
        [loveButton setEnabled:NO];
        [loveButton setAlpha:0.5f];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoveAction) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [SharedAppDelegate.operationQueue addOperation:operation];
    }
    
}

- (void)synchronizeScrobbleAction {
	time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    [SharedAppDelegate.lastfmService scrobbleTrack:trackNameLabel.text byArtist:artistNameLabel.text onAlbum:@"" withDuration:1 timestamp:unixTime streamId:@""];
    
    //NSLog(@"code %d", [SharedAppDelegate.lastfmService.error code]);
    //NSLog(@"domain %@", [SharedAppDelegate.lastfmService.error domain]);
    //NSLog(@"desc %@", [SharedAppDelegate.lastfmService.error localizedDescription]);
    //NSLog(@"Time: %ld", unixTime);
	
	[self performSelectorOnMainThread:@selector(completeScrobbleAction:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeScrobbleAction:(NSError*)error {
    NSLog(@"completeScrobbleAction");
    
    [scrobbleButton setEnabled:YES];
    [scrobbleButton setAlpha:1];
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    UIAlertView *alert;
    if ([error code]) {
        alert = [[UIAlertView alloc] initWithTitle:nil
                                            message:NSLocalizedString([error localizedDescription], @"error")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:nil
                                            message:NSLocalizedString(@"POST_SUCCESS_BODY",@"Post Successfull")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil];
    }
    
	[alert show];
}


- (void)synchronizeLoveAction {
	if (lovedTrack) {
        NSLog(@"loveTrack");
        [SharedAppDelegate.lastfmService loveTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    } else {
        NSLog(@"unloveTrack");
        [SharedAppDelegate.lastfmService unloveTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    }
    
    //NSLog(@"%d", [LastFMService sharedInstance].error.code);
    //NSLog(@"%@", [LastFMService sharedInstance].error.domain);
	
	[self performSelectorOnMainThread:@selector(completeLoveAction:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeLoveAction:(NSError*)error {
    NSLog(@"completeLoveAction");
    
    [loveButton setEnabled:YES];
    [loveButton setAlpha:1];
    
    UIAlertView *alert;
    if ([error code]) {
        alert = [[UIAlertView alloc] initWithTitle:nil
                                            message:NSLocalizedString([error localizedDescription], @"error")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil];
        if (lovedTrack) {
            lovedTrack = NO;
        } else {
            lovedTrack = YES;
        }
    } else {
        if (lovedTrack) {
            alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:NSLocalizedString(@"LOVE_SUCCESS_BODY",@"Love successfull")
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                      otherButtonTitles:nil, nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:NSLocalizedString(@"UNLOVE_SUCCESS_BODY",@"Unlove successfull")
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                      otherButtonTitles:nil, nil];
        }
    }
    
    if (lovedTrack) {
        [loveButton setHighlighted:YES];
    } else {
        [loveButton setHighlighted:NO];
    }
    
	[alert show];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, -50);
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
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (void)synchronizeGetTrackInfoAction {
	NSString *artistName = artistNameLabel.text;
    NSString *trackName = trackNameLabel.text;
    
    //NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    self.trackInfo = [SharedAppDelegate.lastfmService metadataForTrack:trackName byArtist:artistName inLanguage:@""];
    NSLog(@"trackInfo: %@", self.trackInfo);
    
    //NSLog(@"code %d", [service.error code]);
    //NSLog(@"domain %@", [service.error domain]);
    //NSLog(@"desc %@", [service.error localizedDescription]);
	
	[self performSelectorOnMainThread:@selector(completeGetTrackInfoAction:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeGetTrackInfoAction:(NSError*)error {
    NSLog(@"completeGetTrackInfoAction");
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    if (![error code]) {
        if ([[self.trackInfo objectForKey:@"image"] isKindOfClass:[NSString class]] && [[self.trackInfo objectForKey:@"image"] length]) {
            
            NSURL *url = [NSURL URLWithString:[self.trackInfo objectForKey:@"image"]];
            NSString *hash = [[self.trackInfo objectForKey:@"image"] md5sum];
            NSString *key = [NSString stringWithFormat:@"track_cover_%@", hash];
            
            NSData *imageData = [SharedAppDelegate.fileUtil getDataFromUrlAndKey:url key:key];
            
            UIImage *img = [[UIImage alloc] initWithData:imageData];
            self.trackImageView.image = img;
            self.trackImageView.alpha = 1.f;
            self.trackImageView.backgroundColor = [UIColor clearColor];
            self.trackImageView.layer.cornerRadius = 10.f;
            self.trackImageView.clipsToBounds = YES;
        } else {
            self.trackImageView.image = nil;
            self.trackImageView.clipsToBounds = YES;
            self.trackImageView.alpha = 0.5f;
            self.trackImageView.backgroundColor = [UIColor lightGrayColor];
        }
        
        if ([[self.trackInfo objectForKey:@"userloved"] intValue]) {
            [loveButton setHighlighted:YES];
            self.lovedTrack = YES;
        } else {
            [loveButton setHighlighted:NO];
            self.lovedTrack = NO;
        }
        
        NSMutableString *tagString = [[NSMutableString alloc] init];
        if ([[trackInfo objectForKey:@"tags"] isKindOfClass:[NSArray class]]) {
            for (NSString *tag in [trackInfo objectForKey:@"tags"]) {
                [tagString appendFormat:@"%@ ", tag];
            }
        }
        
        NSLog(@"Tags: %@", tagString);
        tagTextView.text = tagString;
        
        self.lastfmPage = [self.trackInfo objectForKey:@"url"];
    } else {
        self.lastfmPage = @"";
    }
    
    [shareButton setEnabled:YES];
    [shareButton setAlpha:1];
}

@end
