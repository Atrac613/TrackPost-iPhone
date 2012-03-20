//
//  ShareViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/20/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface ShareViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UINavigationItem *navigationItem;
    UIToolbar *toolBar;
    PendingView *pendingView;
    BOOL doTweet;
    BOOL doFacebook;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) PendingView *pendingView;
@property (nonatomic) BOOL doTweet;
@property (nonatomic) BOOL doFacebook;

- (void)showPendingView;
- (void)hidePendingView;

- (void)cancelButtonPressed;
- (void)doneButtonPressed;
- (void)closeButtonPressed;

@end
