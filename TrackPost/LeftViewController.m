//
//  LeftViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "TrackListViewController.h"
#import "AppDelegate.h"
#import "LastFMService.h"
#import "ScrobblerViewController.h"
#import "MasterViewController.h"
#import "NSString+MD5.h"
#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // Last.fm section.
        return 5;
    } else {
        // Others section.
        return 2;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"LASTFM", @"");
    } else {
        return NSLocalizedString(@"OTHERS", @"");
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
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"LOVED_TRACKS", @"");
        } else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"WEEKLY_TRACKS", @"");
        } else {
            cell.textLabel.text = NSLocalizedString(@"TOP_TRACKS", @"");
        }
        
    } else {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"ABOUT", @"");
        } else if (indexPath.row == 1) {
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
                } else {
                    TrackListViewController *trackListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackListViewController"];
                    
                    if (indexPath.row == 2) {
                        trackListViewController.trackMode = @"loved";
                    } else if (indexPath.row == 3) {
                        trackListViewController.trackMode = @"weekly";
                    } else if (indexPath.row == 4) {
                        trackListViewController.trackMode = @"top";
                    } else {
                        trackListViewController.trackMode = @"recent";
                    }
                    
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:trackListViewController];
                    self.viewDeckController.centerController = navController;
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    AboutViewController *aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
                    
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
                    self.viewDeckController.centerController = navController;
                } else {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_user"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_session"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [LastFMService sharedInstance].session = nil;
                    
                    MasterViewController *masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
                    
                    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
                    self.viewDeckController.centerController = navController;
                }
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
    
    NSString *hash = [[userProfileDictionary valueForKey:@"avatar"] md5sum];
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%@.dat", hash]];
    
    NSURL *url = [NSURL URLWithString:[userProfileDictionary valueForKey:@"avatar"]];
    NSData *imageData;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        imageData = [NSData dataWithContentsOfURL:url];
        [imageData writeToFile:path atomically:YES];
        NSLog(@"Avatar Url:%@ ImageSize:%d", [url absoluteString], [imageData length]);
    } else {
        NSLog(@"File Exists! Avatar Url: %@", [url absoluteString]);
        imageData = [NSData dataWithContentsOfFile:path];
    }

    profileImageView.image = [UIImage imageWithData:imageData];
    
    self.profileImageView.alpha = 1.f;
    self.profileImageView.backgroundColor = [UIColor clearColor];
    self.profileImageView.layer.cornerRadius = 5.f;
    self.profileImageView.clipsToBounds = YES;
}

@end
