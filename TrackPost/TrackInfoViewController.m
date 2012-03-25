//
//  TrackInfoViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "TrackInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "NSString+MD5.h"

@interface TrackInfoViewController ()

@end

@implementation TrackInfoViewController

@synthesize trackNameLabel;
@synthesize artistNameLabel;
@synthesize trackInfo;
@synthesize trackImageView;
@synthesize listenersTitleLabel;
@synthesize playcountTitleLabel;
@synthesize tagsTitleLabel;
@synthesize userplaycountTitleLabel;
@synthesize loveButton;
@synthesize tagTextView;
@synthesize tagArray;
@synthesize lovedTrack;
@synthesize enabledBackButton;

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
	
    [self.navigationItem setTitle:NSLocalizedString(@"TRACK_INFO", @"Track Info")];
    
    if (!enabledBackButton) {
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
        
    }
    
    self.artistNameLabel.text = [trackInfo objectForKey:@"artist"];
    self.trackNameLabel.text = [trackInfo objectForKey:@"name"];
    
    NSNumber *listenersNumber = [[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"listeners"] intValue]];
    NSNumber *playcountNumber = [[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"playcount"] intValue]];
    NSNumber *userplaycountNumber = [[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"userplaycount"] intValue]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    [listenersTitleLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"LISTENERS", @"Listeners"), [formatter stringForObjectValue:listenersNumber]]];
    [playcountTitleLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"PLAY_COUNT", @"Play Count"), [formatter stringForObjectValue:playcountNumber]]];
    [userplaycountTitleLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"YOUR_PLAY_COUNT", @"Your Play Count"), [formatter stringForObjectValue:userplaycountNumber]]];
    [tagsTitleLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"TAGS", @"Tags")]];
    
    self.trackImageView.backgroundColor = [UIColor lightGrayColor];
    self.trackImageView.alpha = 0.5f;
    self.trackImageView.layer.cornerRadius = 10.f;
    self.trackImageView.clipsToBounds = YES;
    
    if ([[trackInfo objectForKey:@"userloved"] intValue]) {
        [loveButton setHighlighted:YES];
        lovedTrack = YES;
    } else {
        [loveButton setHighlighted:NO];
        lovedTrack = NO;
    }
    
    NSMutableString *tagString = [[NSMutableString alloc] init];
    if ([[trackInfo objectForKey:@"tags"] isKindOfClass:[NSArray class]]) {
        for (NSString *tag in [trackInfo objectForKey:@"tags"]) {
            [tagString appendFormat:@"%@ ", tag];
        }
    }
    
    tagTextView.text = tagString;
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTrackCoverAction) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [SharedAppDelegate.operationQueue addOperation:operation];
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

- (IBAction)lovedButtonPressed:(id)sender {
    NSLog(@"lovedButtonPressed");
    
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

- (void)synchronizeGetTagsAction {
	tagArray = [SharedAppDelegate.lastfmService tagsForTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    //NSLog(@"tagArray: %@", tagArray);
    //NSLog(@"%d", [LastFMService sharedInstance].error.code);
    //NSLog(@"%@", [LastFMService sharedInstance].error.domain);
	
	[self performSelectorOnMainThread:@selector(completeGetTagsAction:) withObject:SharedAppDelegate.lastfmService.error waitUntilDone:YES];
}

- (void)completeGetTagsAction:(NSError*)error {
    NSLog(@"completeGetTagsAction");
    
    if ([error code]) {
        tagTextView.text = @"Error...";
    } else {
        NSMutableString *tags = [[NSMutableString alloc] init];
        for (NSDictionary *tag in tagArray) {
            [tags appendFormat:@"%@(%@) ", [tag objectForKey:@"name"], [tag objectForKey:@"count"]];
        }
    }
}

- (void)synchronizeGetTrackCoverAction {
    if ([[trackInfo objectForKey:@"image"] isKindOfClass:[NSString class]] && [[trackInfo objectForKey:@"image"] length]) {
        
        NSString *hash = [[self.trackInfo objectForKey:@"image"] md5sum];
        
        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"track_cover_%@.dat", hash]];
        
        NSURL *url = [NSURL URLWithString:[self.trackInfo objectForKey:@"image"]];
        NSData *imageData;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            imageData = [NSData dataWithContentsOfURL:url];
            [imageData writeToFile:path atomically:YES];
            NSLog(@"Url:%@ ImageSize:%d", [url absoluteString], [imageData length]);
        } else {
            NSLog(@"File Exists! Url: %@", [url absoluteString]);
            imageData = [NSData dataWithContentsOfFile:path];
        }
        
        UIImage *img = [[UIImage alloc] initWithData:imageData];
        self.trackImageView.image = img;
        self.trackImageView.backgroundColor = [UIColor clearColor];
        self.trackImageView.alpha = 1.f;
        self.trackImageView.layer.cornerRadius = 10.f;
        self.trackImageView.clipsToBounds = YES;
    }
    
	[self performSelectorOnMainThread:@selector(completeGetTrackCoverAction) withObject:nil waitUntilDone:YES];
}

- (void)completeGetTrackCoverAction {
    NSLog(@"completeGetTrackCoverAction");
}

@end
