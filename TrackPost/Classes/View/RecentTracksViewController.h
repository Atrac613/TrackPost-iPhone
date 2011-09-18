//
//  RecentTracksViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 04/18/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface RecentTracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSArray *recentTracksArray;
    NSDictionary *trackInfo;
    
    PendingView *pendingView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *recentTracksArray;
@property (nonatomic, retain) NSDictionary *trackInfo;

@property (nonatomic, retain) PendingView *pendingView;

- (void)recentTracksUpdate;

- (void)showPendingView;
- (void)hidePendingView;

@end
