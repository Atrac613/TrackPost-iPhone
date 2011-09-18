//
//  TrackInfoViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 11/04/21.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import "TrackInfoViewController.h"
#import "TrackPostAppDelegate.h"
#import "LastFMService.h"
#import <QuartzCore/QuartzCore.h>

@implementation TrackInfoViewController

@synthesize trackNameLabel;
@synthesize artistNameLabel;
@synthesize trackInfo;
@synthesize trackImageView;
@synthesize listenersLabel;
@synthesize playcountLabel;
@synthesize userplaycountLabel;
@synthesize loveButton;
@synthesize tagTextView;
@synthesize tagArray;
@synthesize lovedTrack;

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
    
    [self.navigationItem setTitle:@"Track Info"];
    
    self.artistNameLabel.text = [trackInfo objectForKey:@"artist"];
    self.trackNameLabel.text = [trackInfo objectForKey:@"name"];
    
    NSNumber *listenersNumber = [[[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"listeners"] intValue]] autorelease];
    NSNumber *playcountNumber = [[[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"playcount"] intValue]] autorelease];
    NSNumber *userplaycountNumber = [[[NSNumber alloc] initWithInt:[[trackInfo objectForKey:@"userplaycount"] intValue]] autorelease];
    
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    self.listenersLabel.text = [formatter stringForObjectValue:listenersNumber];
    self.playcountLabel.text = [formatter stringForObjectValue:playcountNumber];
    self.userplaycountLabel.text = [formatter stringForObjectValue:userplaycountNumber];
    
    if ([[trackInfo objectForKey:@"image"] isKindOfClass:[NSString class]] && [[trackInfo objectForKey:@"image"] length]) {
        NSURL *url = [NSURL URLWithString:[trackInfo objectForKey:@"image"]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        UIImage* img = [[UIImage alloc] initWithData:data];
        self.trackImageView.image = img;
        self.trackImageView.backgroundColor = [UIColor clearColor];
    } else {
        self.trackImageView.backgroundColor = [UIColor lightGrayColor];
        self.trackImageView.alpha = 0.5f;
        self.trackImageView.layer.cornerRadius = 10.f;
        self.trackImageView.clipsToBounds = YES;
    }
    
    if ([[trackInfo objectForKey:@"userloved"] intValue]) {
        [self.loveButton setHighlighted:YES];
        lovedTrack = YES;
    } else {
        [self.loveButton setHighlighted:NO];
        lovedTrack = NO;
    }
    
    NSMutableString *tagString = [[[NSMutableString alloc] init] autorelease];
    if ([[trackInfo objectForKey:@"tags"] isKindOfClass:[NSArray class]]) {
        for (NSString *tag in [trackInfo objectForKey:@"tags"]) {
            [tagString appendFormat:@"%@ ", tag];
        }
    }
    
    tagTextView.text = tagString;
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

- (IBAction)lovedButtonPressed:(id)sender {
    NSLog(@"lovedButtonPressed");
    
    if (lovedTrack) {
        lovedTrack = NO;
    } else {
        lovedTrack = YES;
    }
    
    [loveButton setEnabled:NO];
    [loveButton setAlpha:0.5f];
    
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoveAction) object:nil] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
}


- (void)synchronizeLoveAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;

    if (lovedTrack) {
        NSLog(@"loveTrack");
        [service loveTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    } else {
        NSLog(@"unloveTrack");
        [service unloveTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    }
    
    //NSLog(@"%d", [LastFMService sharedInstance].error.code);
    //NSLog(@"%@", [LastFMService sharedInstance].error.domain);
	
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
        if (lovedTrack) {
            lovedTrack = NO;
        } else {
            lovedTrack = YES;
        }
    } else {
        alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOVE_SUCCESS_TITLE", @"Love successful title")
                                            message:NSLocalizedString(@"LOVE_SUCCESS_BODY",@"Love Successfull")
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                  otherButtonTitles:nil, nil] autorelease];
    }
    
    if (lovedTrack) {
        [self.loveButton setHighlighted:YES];
    } else {
        [self.loveButton setHighlighted:NO];
    }
    
	[alert show];
}


- (void)synchronizeGetTagsAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;
    //NSLog(@"session: %@", session);
    
    tagArray = [service tagsForTrack:trackNameLabel.text byArtist:artistNameLabel.text];
    //NSLog(@"tagArray: %@", tagArray);
    //NSLog(@"%d", [LastFMService sharedInstance].error.code);
    //NSLog(@"%@", [LastFMService sharedInstance].error.domain);
	
	[self performSelectorOnMainThread:@selector(completeGetTagsAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetTagsAction:(NSError*)error {
    NSLog(@"Get Tags Success");

    if ([error code]) {
        tagTextView.text = @"Error...";
    } else {
        NSMutableString *tags = [[[NSMutableString alloc] init] autorelease];
        for (NSDictionary *tag in tagArray) {
            [tags appendFormat:@"%@(%@) ", [tag objectForKey:@"name"], [tag objectForKey:@"count"]];
        }
        //NSLog(@"Tags; %@", tags);
        //tagTextView.text = tags;
    }
}



@end
