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
#import "LoginViewController.h"
#import "ScrobblerViewController.h"

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"TrackPost"];
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_session"];
    if ([session length]) {
        NSLog(@"Session key found.");
        
        // Refresh Side Controller.
        [[self.viewDeckController rightController] viewWillAppear:YES];
        [[self.viewDeckController leftController] viewWillAppear:YES];
        
        ScrobblerViewController *scrobblerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrobblerViewController"];
        [self.navigationController pushViewController:scrobblerViewController animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)loginButtonPressed:(id)sender {
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentModalViewController:loginViewController animated:YES];
}

@end
