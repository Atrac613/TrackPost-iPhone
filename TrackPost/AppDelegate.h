//
//  AppDelegate.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <SystemConfiguration/SCNetworkReachability.h>
#include "version.h"
#import "FBConnect.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSOperationQueue *operationQueue;
    UIAlertView *_pendingAlert;
    BOOL _locked;
    
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

@property (nonatomic, retain) Facebook *facebook;

-(BOOL)hasNetworkConnection;
-(BOOL)hasWiFiConnection;

-(void)displayError:(NSString *)error withTitle:(NSString *)title;

@end
