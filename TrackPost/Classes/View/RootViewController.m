//
//  RootViewController.m
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import "RootViewController.h"
#import "LastFMService.h"
#import "TrackPostAppDelegate.h"
#import "ScrobblerViewController.h"

@implementation RootViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [passwordField setSecureTextEntry:YES];
    
    [self.navigationItem setTitle:@"TrackPost"];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    if ([session length]) {
        NSLog(@"Session key found.");
        ScrobblerViewController *scrobblerViewController = [[[ScrobblerViewController alloc] init] autorelease];
        [self.navigationController pushViewController:scrobblerViewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}


-(IBAction)loginButtonPressed:(id)sender {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    TrackPostAppDelegate *trackPostAppDelegate = (TrackPostAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoginAction) object:nil] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [trackPostAppDelegate.operationQueue addOperation:operation];
}

- (void)synchronizeLoginAction {
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    NSLog(@"Username: %@, Password: %@", username, password);
    
    NSDictionary *session = [[LastFMService sharedInstance] getMobileSessionForUser:username password:password];
    NSLog(@"%@", session);
    if([[session objectForKey:@"key"] length]) {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"lastfm_user"];
        [[NSUserDefaults standardUserDefaults] setObject:[session objectForKey:@"key"] forKey:@"lastfm_session"];
        [[NSUserDefaults standardUserDefaults] setObject:[session objectForKey:@"subscriber"] forKey:@"lastfm_subscriber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Login Success");
	}
    
    [self performSelectorOnMainThread:@selector(completeLoginAction:) withObject:[LastFMService sharedInstance].error waitUntilDone:YES];
}

- (void)completeLoginAction:(NSError*)error {
    NSLog(@"Login Action Success");
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    if ([error code]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AUTH_ERROR_TITLE", @"Auth error title")
                                                         message:NSLocalizedString([error localizedDescription], @"error")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                               otherButtonTitles:nil, nil] autorelease];
        [alert show];
    } else {
        ScrobblerViewController *scrobblerViewController = [[[ScrobblerViewController alloc] init] autorelease];
        [self.navigationController pushViewController:scrobblerViewController animated:YES];
    }
    
}


@end
