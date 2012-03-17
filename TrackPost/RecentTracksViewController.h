//
//  RecentTracksViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/17/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface RecentTracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSArray *recentTracksArray;
    NSDictionary *trackInfo;
    PendingView *pendingView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *recentTracksArray;
@property (nonatomic, retain) NSDictionary *trackInfo;
@property (nonatomic, retain) PendingView *pendingView;

- (void)recentTracksUpdate;

- (void)showPendingView;
- (void)hidePendingView;

@end
