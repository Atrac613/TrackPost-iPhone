//
//  ShareViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/20/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "FBConnect.h"

@interface ShareViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FBSessionDelegate, FBRequestDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UINavigationItem *navigationItem;
    UIToolbar *toolBar;
    NSString *artistName;
    NSString *trackName;
    NSString *lastfmPage;
    NSString *shareMessage;
    NSString *shareMessageMinimum;
    PendingView *pendingView;
    BOOL doTweet;
    BOOL doFacebook;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSString *artistName;
@property (nonatomic, retain) NSString *trackName;
@property (nonatomic, retain) NSString *lastfmPage;
@property (nonatomic, retain) NSString *shareMessage;
@property (nonatomic, retain) NSString *shareMessageMinimum;
@property (nonatomic, retain) PendingView *pendingView;
@property (nonatomic) BOOL doTweet;
@property (nonatomic) BOOL doFacebook;

- (void)showPendingView;
- (void)hidePendingView;

- (void)cancelButtonPressed;
- (void)doneButtonPressed;
- (void)closeButtonPressed;

- (void)sendFacebook:(NSString *)message url:(NSString*)url;
- (void)sendTwitter:(NSString *)message;

@end
