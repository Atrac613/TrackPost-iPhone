//
//  MasterViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "MasterViewController.h"
#import "IIViewDeckController.h"
#import "LastFMService.h"
#import "AppDelegate.h"

@implementation MasterViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize pendingView;
@synthesize messageLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    
    [passwordField setSecureTextEntry:YES];
    
    [self.navigationItem setTitle:@"TrackPost"];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    if ([session length]) {
        NSLog(@"Session key found.");
        //ScrobblerViewController *scrobblerViewController = [[[ScrobblerViewController alloc] init] autorelease];
        //[self.navigationController pushViewController:scrobblerViewController animated:YES];
    }
    
    [messageLabel setText:NSLocalizedString(@"LOGIN_WITH_LASTFM_ACCOUNT", @"Login with your Last.fm account.")];
    [loginButton setTitle:NSLocalizedString(@"LOGIN", @"Login") forState:UIControlStateNormal];
    [usernameField setPlaceholder:NSLocalizedString(@"USERNAME", @"Username")];
    [passwordField setPlaceholder:NSLocalizedString(@"PASSWORD", @"Password")];
    
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)loginButtonPressed:(id)sender {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    [self showPendingView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoginAction) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [appDelegate.operationQueue addOperation:operation];
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
    NSLog(@"completeLoginAction");
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    [self hidePendingView];
    
    if ([error code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AUTH_ERROR_TITLE", @"Auth error title")
                                                         message:NSLocalizedString([error localizedDescription], @"error")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                               otherButtonTitles:nil, nil];
        [alert show];
    } else {
        //ScrobblerViewController *scrobblerViewController = [[[ScrobblerViewController alloc] init] autorelease];
        //[self.navigationController pushViewController:scrobblerViewController animated:YES];
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
