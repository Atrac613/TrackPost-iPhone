//
//  RightViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "RightViewController.h"
#import "NSString+MD5.h"
#import "TrackInfoViewController.h"
#import "IIViewDeckController.h"

@interface RightViewController ()

@end

@implementation RightViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize button7;
@synthesize button8;
@synthesize button9;
@synthesize button10;
@synthesize button11;
@synthesize button12;
@synthesize button13;
@synthesize button14;
@synthesize button15;
@synthesize button16;
@synthesize button17;
@synthesize button18;
@synthesize button19;
@synthesize button20;
@synthesize lovedTracksArray;
@synthesize rankArray;
@synthesize trackInfo;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Right viewWillAppear");
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:LASTFM_KEY_SESSION];
    if ([session length]) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetLovedTracks) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [SharedAppDelegate.operationQueue addOperation:operation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)synchronizeGetLovedTracks {
    NSLog(@"synchronizeGetLovedTracks");
    
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:LASTFM_KEY_USER];
    self.lovedTracksArray = [SharedAppDelegate.lastfmService lovedTracksForUser:username];
    //NSLog(@"%@", self.lovedTracksArray);
	[self performSelectorOnMainThread:@selector(completeGetLovedTracks:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeGetLovedTracks:(NSError*)error {
    NSLog(@"completeGetLovedTracks");
    
    NSInvocationOperation *operation;
    
    NSInteger maxImage = 20;
    NSInteger imageCount = 0;
    NSString *hash;
    NSString *artistName;
    NSString *trackName;
    
    rankArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [lovedTracksArray count]; i++) {
        NSString *imageUrl = [[lovedTracksArray objectAtIndex:i] valueForKey:@"image"];
        if ([imageUrl length] > 0) {
            
            hash = [imageUrl md5sum];
            artistName = [[lovedTracksArray objectAtIndex:i] valueForKey:@"artist"];
            trackName = [[lovedTracksArray objectAtIndex:i] valueForKey:@"name"];
            
            // Array key index.
            // 0: hash
            // 1: artistName
            // 2: trackName
            [rankArray addObject:[[NSArray alloc] initWithObjects:hash, artistName, trackName, nil]];
            
            operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetLovedTracksCoverImage:) object:[[NSArray alloc] initWithObjects:[NSURL URLWithString:imageUrl], [NSNumber numberWithInt:imageCount], hash, nil]];
            [operation setQueuePriority:NSOperationQueuePriorityLow];
            [SharedAppDelegate.operationQueue addOperation:operation];
            
            if (imageCount >= maxImage) {
                break;
            }
            
            imageCount++;
        }
    }
}

- (void)synchronizeGetLovedTracksCoverImage:(NSArray*)object {
    NSLog(@"synchronizeGetLovedTracksCoverImage");
    
    NSURL *url = [object objectAtIndex:0];
    NSInteger rank = [[object objectAtIndex:1] intValue];
    NSString *hash = [object objectAtIndex:2];
    
    NSString *key = [NSString stringWithFormat:@"track_cover_%@", hash];
    
    [SharedAppDelegate.fileUtil createCacheFileFromUrlAndKey:url key:key];
    
	[self performSelectorOnMainThread:@selector(completeGetLovedTracksCoverImage:) withObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:rank], nil] waitUntilDone:YES];
}

- (void)completeGetLovedTracksCoverImage:(NSArray*)object {
    NSLog(@"completeGetLovedTracksCoverImage");
    
    NSInteger rank = [[object objectAtIndex:0] intValue];
    NSArray *trackInfoArray = [rankArray objectAtIndex:rank];
    
    // Array key index.
    // 0: hash
    // 1: artistName
    // 2: trackName
    NSString *hash = [trackInfoArray objectAtIndex:0];
    
    NSString *key = [NSString stringWithFormat:@"track_cover_%@", hash];
    
    NSData *imageData = [SharedAppDelegate.fileUtil getDataFromKey:key];
    UIImage *image = [UIImage imageWithData:imageData];
    
    // I really hate this code...
    if (rank == 0) {
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 1) {
        [button2 setBackgroundImage:image forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 2) {
        [button3 setBackgroundImage:image forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 3) {
        [button4 setBackgroundImage:image forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(button4Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 4) {
        [button5 setBackgroundImage:image forState:UIControlStateNormal];
        [button5 addTarget:self action:@selector(button5Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 5) {
        [button6 setBackgroundImage:image forState:UIControlStateNormal];
        [button6 addTarget:self action:@selector(button6Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 6) {
        [button7 setBackgroundImage:image forState:UIControlStateNormal];
        [button7 addTarget:self action:@selector(button7Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 7) {
        [button8 setBackgroundImage:image forState:UIControlStateNormal];
        [button8 addTarget:self action:@selector(button8Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 8) {
        [button9 setBackgroundImage:image forState:UIControlStateNormal];
        [button9 addTarget:self action:@selector(button9Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 9) {
        [button10 setBackgroundImage:image forState:UIControlStateNormal];
        [button10 addTarget:self action:@selector(button10Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 10) {
        [button11 setBackgroundImage:image forState:UIControlStateNormal];
        [button11 addTarget:self action:@selector(button11Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 11) {
        [button12 setBackgroundImage:image forState:UIControlStateNormal];
        [button12 addTarget:self action:@selector(button12Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 12) {
        [button13 setBackgroundImage:image forState:UIControlStateNormal];
        [button13 addTarget:self action:@selector(button13Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 13) {
        [button14 setBackgroundImage:image forState:UIControlStateNormal];
        [button14 addTarget:self action:@selector(button14Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 14) {
        [button15 setBackgroundImage:image forState:UIControlStateNormal];
        [button15 addTarget:self action:@selector(button15Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 15) {
        [button16 setBackgroundImage:image forState:UIControlStateNormal];
        [button16 addTarget:self action:@selector(button16Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 16) {
        [button17 setBackgroundImage:image forState:UIControlStateNormal];
        [button17 addTarget:self action:@selector(button17Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 17) {
        [button18 setBackgroundImage:image forState:UIControlStateNormal];
        [button18 addTarget:self action:@selector(button18Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 18) {
        [button19 setBackgroundImage:image forState:UIControlStateNormal];
        [button19 addTarget:self action:@selector(button19Pressed) forControlEvents:UIControlEventTouchUpInside];
    } else if (rank == 19) {
        [button20 setBackgroundImage:image forState:UIControlStateNormal];
        [button20 addTarget:self action:@selector(button20Pressed) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)button1Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:0]];
}

- (void)button2Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:1]];
}

- (void)button3Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:2]];
}

- (void)button4Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:3]];
}

- (void)button5Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:4]];
}

- (void)button6Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:5]];
}

- (void)button7Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:6]];
}

- (void)button8Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:7]];
}

- (void)button9Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:8]];
}

- (void)button10Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:9]];
}

- (void)button11Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:10]];
}

- (void)button12Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:11]];
}

- (void)button13Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:12]];
}

- (void)button14Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:13]];
}

- (void)button15Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:14]];
}

- (void)button16Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:15]];
}

- (void)button17Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:16]];
}

- (void)button18Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:17]];
}

- (void)button19Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:18]];
}

- (void)button20Pressed {
    [self getTrackInfo:[rankArray objectAtIndex:19]];
}

- (void)getTrackInfo:(NSArray*)object {
    [self showPendingView];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTrackInfoAction:) object:object];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [SharedAppDelegate.operationQueue addOperation:operation];
}

- (void)synchronizeGetTrackInfoAction:(NSArray*)object {
	// Array key index.
    // 0: hash
    // 1: artistName
    // 2: trackName
    NSString *artistName = [object objectAtIndex:1];
    NSString *trackName = [object objectAtIndex:2];
    
    trackInfo = [SharedAppDelegate.lastfmService metadataForTrack:trackName byArtist:artistName inLanguage:@""];
    
	[self performSelectorOnMainThread:@selector(completeGetTrackInfoAction:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeGetTrackInfoAction:(NSError*)error {
    NSLog(@"completeGetTrackInfoAction");
    
    [self hidePendingView];
    
    if (![error code]) {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
                TrackInfoViewController *trackInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackInfoViewController"];
                trackInfoViewController.trackInfo = self.trackInfo;
                trackInfoViewController.enabledBackButton = NO;
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:trackInfoViewController];
                self.viewDeckController.centerController = navController;
            }
            //[NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
        }];
    }
}

- (void)showPendingView {
    if (pendingView == nil && ![self.view.subviews containsObject:pendingView]) {
        pendingView = [[FullScreenPendingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        pendingView.userInteractionEnabled = YES;
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
