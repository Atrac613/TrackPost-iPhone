//
//  TrackPostAppDelegate.m
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import "TrackPostAppDelegate.h"
#include <SystemConfiguration/SCNetworkReachability.h>
#include "version.h"

@implementation TrackPostAppDelegate

NSString *kUserAgent;

@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize operationQueue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // operation queue
	self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
	[self.operationQueue setMaxConcurrentOperationCount:1];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (id)init {
    self = [super init];
	if (self) {
		kUserAgent = [[NSString alloc] initWithFormat:@"TrackPost/%@ (%@; %@; %@ %@)", VERSION, [UIDevice currentDevice].model, [[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] objectAtIndex:0], [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
		NSLog(@"%@", kUserAgent);
    }
    
    return self;
}

-(BOOL)hasNetworkConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "ws.audioscrobbler.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkReachabilityFlagsReachable & flags) || (kSCNetworkReachabilityFlagsConnectionRequired & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}
-(BOOL)hasWiFiConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "ws.audioscrobbler.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkFlagsReachable & flags) && !(kSCNetworkReachabilityFlagsIsWWAN & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}

-(void)displayError:(NSString *)error withTitle:(NSString *)title {
	_pendingAlert = [[UIAlertView alloc] initWithTitle:title message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	if(!_locked)
		[_pendingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
