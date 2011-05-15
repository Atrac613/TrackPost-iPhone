//
//  RecentTracksViewController.m
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/18.
//  Copyright 2011 envision. All rights reserved.
//

#import "RecentTracksViewController.h"
#import "TrackPostAppDelegate.h"
#import "LastFMService.h"
#import "TrackCell.h"
#import "TrackInfoViewController.h"

@implementation RecentTracksViewController

@synthesize tableView;
@synthesize recentTracksArray;
@synthesize trackInfo;

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
    
    [self.navigationItem setTitle:@"Recent Tracks"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(recentTracksUpdate)];
    
    [self recentTracksUpdate];
}

- (void)recentTracksUpdate {
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetRecentTracksAction) object:nil] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
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

- (void)synchronizeGetRecentTracksAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    self.recentTracksArray = [service recentlyPlayedTracksForUser:username];
	
	[self performSelectorOnMainThread:@selector(completeGetRecentTracksAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetRecentTracksAction:(NSError*)error {
    NSLog(@"completeGetRecentTracksAction Success");
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recentTracksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *cell = (TrackCell *)[tv dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[TrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    
    NSDictionary *rowData = [self.recentTracksArray objectAtIndex:indexPath.row];
    
    NSTimeInterval timeInterval = [[rowData objectForKey:@"uts"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    cell.artistNameLabel.text = [rowData objectForKey:@"artist"];
    cell.trackNameLabel.text = [rowData objectForKey:@"name"];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    if ([[rowData objectForKey:@"nowplaying"] boolValue]) {
        cell.dateLabel.text = @"nowplaying";
    } else {
        cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *rowData = [self.recentTracksArray objectAtIndex:indexPath.row];
    
    NSString *artistName = [rowData objectForKey:@"artist"];
    NSString *trackName = [rowData objectForKey:@"name"];
    
    NSLog(@"artistName: %@", artistName);
    NSLog(@"trackName: %@", trackName);
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTrackInfoAction:) object:rowData] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
    
}

- (void)synchronizeGetTrackInfoAction:(NSDictionary*)rowData {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[[LastFMService alloc] init] autorelease];
    service.session = session;
    
    NSString *artistName = [rowData objectForKey:@"artist"];
    NSString *trackName = [rowData objectForKey:@"name"];

    trackInfo = [service metadataForTrack:trackName byArtist:artistName inLanguage:@""];
	
	[self performSelectorOnMainThread:@selector(completeGetTrackInfoAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetTrackInfoAction:(NSError*)error {
    NSLog(@"completeGetTrackInfoAction Success");
    
    if (![error code]) {
        TrackInfoViewController *trackInfoViewController = [[[TrackInfoViewController alloc] init] autorelease];
        trackInfoViewController.trackInfo = self.trackInfo;
        [self.navigationController pushViewController:trackInfoViewController animated:YES];
    }
}

@end