//
//  AppDelegate.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "MasterViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "Appirater.h"
#import "TestViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;
@synthesize operationQueue;

NSString *kUserAgent;

- (id)init {
    self = [super init];
	if (self) {
		kUserAgent = [[NSString alloc] initWithFormat:@"TrackPost/%@ (%@; %@; %@ %@)", VERSION, [UIDevice currentDevice].model, [[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] objectAtIndex:0], [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
		NSLog(@"%@", kUserAgent);
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    self.leftController = (LeftViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftViewController"];
    RightViewController *rightController = (RightViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"RightViewController"];
    
    MasterViewController *centerController = (MasterViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MasterViewController"];
    self.centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    
    IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController 
                                                                                    leftViewController:self.leftController
                                                                                   rightViewController:rightController];
    deckController.rightLedge = 100;
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    //[Appirater appLaunched:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //[Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
