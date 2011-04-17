//
//  TrackPostAppDelegate.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackPostAppDelegate : NSObject <UIApplicationDelegate> {
    UIAlertView *_pendingAlert;
    BOOL _locked;
    NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(BOOL)hasNetworkConnection;
-(BOOL)hasWiFiConnection;

-(void)displayError:(NSString *)error withTitle:(NSString *)title;

@end
