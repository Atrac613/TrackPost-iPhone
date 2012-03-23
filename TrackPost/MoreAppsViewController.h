//
//  MoreAppsViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/24/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface MoreAppsViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    
    PendingView *pendingView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) PendingView *pendingView;

- (void)showPendingView;
- (void)hidePendingView;

@end
