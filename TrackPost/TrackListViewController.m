//
//  TrackListViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "TrackListViewController.h"
#import "AppDelegate.h"
#import "LastFMService.h"
#import "TrackCell.h"
#import "IIViewDeckController.h"
#import "TrackInfoViewController.h"

@interface TrackListViewController ()

@end

@implementation TrackListViewController

@synthesize tableView;
@synthesize trackMode;
@synthesize trackListsArray;
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
    
    if ([trackMode isEqualToString:@"loved"]) {
        [self.navigationItem setTitle:NSLocalizedString(@"LOVED_TRACKS", @"")];
    } else if ([trackMode isEqualToString:@"top"]) {
        [self.navigationItem setTitle:NSLocalizedString(@"TOP_TRACKS", @"")];
    } else if ([trackMode isEqualToString:@"weekly"]) {
        [self.navigationItem setTitle:NSLocalizedString(@"WEEKLY_TRACKS", @"")];
    } else {
        [self.navigationItem setTitle:NSLocalizedString(@"RECENT_TRACKS", @"")];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(trackListsUpdate)];
    
    [self trackListsUpdate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hidePendingView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)trackListsUpdate {
    [self showPendingView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTracksAction) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [appDelegate.operationQueue addOperation:operation];
}

- (void)synchronizeGetTracksAction {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[LastFMService alloc] init];
    service.session = session;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    
    if ([trackMode isEqualToString:@"loved"]) {
        self.trackListsArray = [service lovedTracksForUser:username];
    } else if ([trackMode isEqualToString:@"top"]) {
        self.trackListsArray = [service topTracksForUser:username];
    } else if ([trackMode isEqualToString:@"weekly"]) {
        self.trackListsArray = [service weeklyTracksForUser:username];
    } else {
        self.trackListsArray = [service recentlyPlayedTracksForUser:username];
    }
    
	[self performSelectorOnMainThread:@selector(completeGetTracksAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetTracksAction:(NSError*)error {
    NSLog(@"completeGetTracksAction");
    
    [self hidePendingView];
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trackListsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackCell *cell = (TrackCell *)[tv dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[TrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *rowData = [NSDictionary dictionaryWithDictionary:[self.trackListsArray objectAtIndex:indexPath.row]];
    
    cell.artistNameLabel.text = [rowData objectForKey:@"artist"];
    cell.trackNameLabel.text = [rowData objectForKey:@"name"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    if ([[rowData objectForKey:@"nowplaying"] boolValue]) {
        cell.dateLabel.text = @"nowplaying";
    } else {
        if ([rowData valueForKey:@"uts"]) {
            NSTimeInterval timeInterval = [[rowData objectForKey:@"uts"] doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            
            cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        } else {            
            cell.dateLabel.text = [NSString stringWithFormat:@"%d", [[rowData valueForKey:@"playcount"] intValue]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *rowData = [self.trackListsArray objectAtIndex:indexPath.row];
    
    NSString *artistName = [rowData objectForKey:@"artist"];
    NSString *trackName = [rowData objectForKey:@"name"];
    
    NSLog(@"artistName: %@", artistName);
    NSLog(@"trackName: %@", trackName);
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self showPendingView];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetTrackInfoAction:) object:rowData];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [appDelegate.operationQueue addOperation:operation];
    
}

- (void)synchronizeGetTrackInfoAction:(NSDictionary*)rowData {
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[LastFMService alloc] init];
    service.session = session;
    
    NSString *artistName = [rowData objectForKey:@"artist"];
    NSString *trackName = [rowData objectForKey:@"name"];
    
    trackInfo = [service metadataForTrack:trackName byArtist:artistName inLanguage:@""];
    
	[self performSelectorOnMainThread:@selector(completeGetTrackInfoAction:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetTrackInfoAction:(NSError*)error {
    NSLog(@"completeGetTrackInfoAction");
    
    if (![error code]) {
        TrackInfoViewController *trackInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackInfoViewController"];
        trackInfoViewController.trackInfo = self.trackInfo;
        trackInfoViewController.enabledBackButton = YES;
        [self.navigationController pushViewController:trackInfoViewController animated:YES];
    }
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
