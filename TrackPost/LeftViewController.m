//
//  LeftViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "RecentTracksViewController.h"
#import "AppDelegate.h"
#import "LastFMService.h"
#import "ScrobblerViewController.h"
#import "MasterViewController.h"

@interface LeftViewController () <IIViewDeckControllerDelegate>

@end

@implementation LeftViewController
@synthesize profileImageView;
@synthesize userNameLabel;
@synthesize userProfileDictionary;

@synthesize tableView;

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
    
    self.viewDeckController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Left viewWillAppear");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    if ([session length]) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeGetProfile) object:nil];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [appDelegate.operationQueue addOperation:operation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - view deck delegate

- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"will open left view");
    return YES;
}

- (void)viewDeckControllerDidOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"did open left view");
}

- (BOOL)viewDeckControllerWillCloseLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"will close left view");
    return YES;
}

- (void)viewDeckControllerDidCloseLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"did close left view");
}

- (BOOL)viewDeckControllerWillOpenRightView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"will open right view");
    return YES;
}

- (void)viewDeckControllerDidOpenRightView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"did open right view");
}

- (BOOL)viewDeckControllerWillCloseRightView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"will close left view");
    return YES;
}

- (void)viewDeckControllerDidCloseRightView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"did close left view");
}

- (void)viewDeckControllerDidShowCenterView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    NSLog(@"did show center view");
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // Last.fm section.
        return 3;
    } else if (section == 1) {
        // Other section.
        return 3;
    } else {
        // Logout section.
        return 1;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"LASTFM", @"");
    } else if (section == 1) {
        return NSLocalizedString(@"OTHER", @"");
    } else {
        return NSLocalizedString(@"LOGOUT", @"");
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return  @"";
}

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"SCROBBLER", @"");
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"RECENT_TRACKS", @"");
        } else {
            cell.textLabel.text = NSLocalizedString(@"LOVED_TRACKS", @"");
        }
        
    } else if (indexPath.section == 1) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"CLEAR_CACHE", @"");
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"ABOUT_THIS_APP", @"");
        } else {
            cell.textLabel.text = NSLocalizedString(@"LICENSE", @"");
        }
        
    } else {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"LOGOUT", @"");
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"indexPath.row: %d", indexPath.row);
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    ScrobblerViewController *scrobblerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrobblerViewController"];
                    
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:scrobblerViewController];
                    self.viewDeckController.centerController = navController;
                } else if (indexPath.row == 1) {
                    RecentTracksViewController *recentTracksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentTracksViewController"];
                    
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:recentTracksViewController];
                    self.viewDeckController.centerController = navController;
                }
            } else if (indexPath.section == 2) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_user"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_session"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [LastFMService sharedInstance].session = nil;
                
                MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
                
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
                self.viewDeckController.centerController = navController;
            }
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
    }];
}

- (void)synchronizeGetProfile {
    NSLog(@"synchronizeGetProfile");
    
	NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    LastFMService *service = [[LastFMService alloc] init];
    service.session = session;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"];
    self.userProfileDictionary = [service profileForUser:username authenticated:YES];
    
	[self performSelectorOnMainThread:@selector(completeGetProfile:) withObject:service.error waitUntilDone:YES];
}

- (void)completeGetProfile:(NSError*)error {
    NSLog(@"completeGetProfile");
    
    userNameLabel.text = [userProfileDictionary valueForKey:@"realname"];
    
    NSLog(@"ImageUrl: %@", [userProfileDictionary valueForKey:@"avatar"]);
    NSURL *url = [NSURL URLWithString:[userProfileDictionary valueForKey:@"avatar"]];
    profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}

@end
