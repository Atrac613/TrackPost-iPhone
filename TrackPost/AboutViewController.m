//
//  AboutViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "AboutViewController.h"
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>
#import "ThirdPartyNoticesViewController.h"
#import "MoreAppsViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize tableView;
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
	
    [self.navigationItem setTitle:NSLocalizedString(@"ABOUT", @"")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80.f;
        }
    }
    
    return 40.f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.imageView.image = [UIImage imageNamed:@"icon.png"];
            cell.imageView.layer.cornerRadius = 10.f;
            cell.imageView.clipsToBounds = YES;
            
            UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 200, 15)];
            [appNameLabel setText:NSLocalizedString(@"TRACKPOST", @"")];
            [appNameLabel setTextColor:[UIColor blackColor]];
            [appNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:appNameLabel];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            UILabel *appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 200, 15)];
            [appVersionLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"VERSION", @""), version]];
            [appVersionLabel setFont:[UIFont systemFontOfSize:10.f]];
            [appVersionLabel setTextColor:[UIColor blackColor]];
            [appVersionLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:appVersionLabel];
            
            UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 52, 200, 15)];
            [authorLabel setText:[NSString stringWithFormat:@"%@: Osamu Noguchi", NSLocalizedString(@"AUTHOR", @"")]];
            [authorLabel setFont:[UIFont systemFontOfSize:10.f]];
            [authorLabel setTextColor:[UIColor blackColor]];
            [authorLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:authorLabel];
        } else if (indexPath.row == 1) {
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.textLabel setText:NSLocalizedString(@"SOURCE_CODE_REPOSITORY", @"")];
        }else {
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.textLabel setText:NSLocalizedString(@"MORE_APPS", @"")];
        }
    } else if (indexPath.section == 1) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:NSLocalizedString(@"THIRD_PARTY_NOTICES", @"")];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        }
    } else if (indexPath.section == 2) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:NSLocalizedString(@"CLEAR_CACHE", @"")];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Atrac613/TrackPost-iPhone"]];
        } else if (indexPath.row == 2) {
            MoreAppsViewController *moreAppsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreAppsViewController"];
            [self.navigationController pushViewController:moreAppsViewController animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ThirdPartyNoticesViewController *thirdPartyNoticesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdPartyNoticesViewController"];
            [self.navigationController pushViewController:thirdPartyNoticesViewController animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showPendingView];
            
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeClearCacheAction) object:nil];
            [operation setQueuePriority:NSOperationQueuePriorityHigh];
            [SharedAppDelegate.operationQueue addOperation:operation];
        }
    }
}

- (void)synchronizeClearCacheAction {
	NSString *extension = @"dat";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];  
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            NSLog(@"Delete File: %@", filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
	[self performSelectorOnMainThread:@selector(completeClearCacheAction) withObject:nil waitUntilDone:YES];
}

- (void)completeClearCacheAction {
    NSLog(@"completeGetClearCacheAction");
    
    [self hidePendingView];
    
    // Refresh Side Controller.
    [[self.viewDeckController rightController] viewWillAppear:YES];
    [[self.viewDeckController leftController] viewWillAppear:YES];
}

- (void)showPendingView {
    if (pendingView == nil && ![self.view.subviews containsObject:pendingView]) {
        pendingView = [[PendingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
        pendingView.titleLabel.text = NSLocalizedString(@"PLEASE_WAIT", @"Please wait");
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
