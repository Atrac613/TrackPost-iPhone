//
//  RightViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"
#import "LastFMService.h"
#import "NSString+MD5.h"

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
@synthesize lovedTracksArray;
@synthesize rankArray;

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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    if ([session length]) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetLovedTracks) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [appDelegate.operationQueue addOperation:operation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)synchronizeGetLovedTracks {
    NSLog(@"synchronizeGetLovedTracks");
    
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[LastFMService alloc] init];
    service.session = session;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    self.lovedTracksArray = [service lovedTracksForUser:username];
    NSLog(@"%@", self.lovedTracksArray);
	[self performSelectorOnMainThread:@selector(completeGetLovedTracks:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetLovedTracks:(NSError*)error {
    NSLog(@"completeGetLovedTracks");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation;
    
    NSInteger maxImage = 15;
    NSInteger imageCount = 0;
    NSString *hash;
    
    rankArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [lovedTracksArray count]; i++) {
        NSString *imageUrl = [[lovedTracksArray objectAtIndex:i] valueForKey:@"image"];
        if ([imageUrl length] > 0) {
            
            hash = [imageUrl md5sum];
            [rankArray addObject:hash];
            
            operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetLovedTracksCoverImage:) object:[[NSArray alloc] initWithObjects:[NSURL URLWithString:imageUrl], [NSNumber numberWithInt:imageCount], hash, nil]];
            [operation setQueuePriority:NSOperationQueuePriorityLow];
            [appDelegate.operationQueue addOperation:operation];
            
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
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"track_cover_%@.dat", hash]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        [imageData writeToFile:path atomically:YES];
        NSLog(@"Url:%@ ImageSize:%d", [url absoluteString], [imageData length]);
    } else {
        NSLog(@"File Exists! Url: %@", [url absoluteString]);
    }
    
	[self performSelectorOnMainThread:@selector(completeGetLovedTracksCoverImage:) withObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:rank], nil] waitUntilDone:YES];
}

- (void)completeGetLovedTracksCoverImage:(NSArray*)object {
    NSLog(@"completeGetLovedTracksCoverImage");
    
    NSInteger rank = [[object objectAtIndex:0] intValue];
    NSString *hash = [rankArray objectAtIndex:rank];
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"track_cover_%@.dat", hash]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    
    NSLog(@"Hash: %@ ImageSize: %d", hash, [[NSData dataWithContentsOfFile:path] length]);
    
    if (rank == 0) {
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 1) {
        [button2 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 2) {
        [button3 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 3) {
        [button4 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 4) {
        [button5 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 5) {
        [button6 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 6) {
        [button7 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 7) {
        [button8 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 8) {
        [button9 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 9) {
        [button10 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 10) {
        [button11 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 11) {
        [button12 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 12) {
        [button13 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 13) {
        [button14 setBackgroundImage:image forState:UIControlStateNormal];
    } else if (rank == 14) {
        [button15 setBackgroundImage:image forState:UIControlStateNormal];
    }
}

@end
