//
//  TrackListViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface TrackListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSString *trackMode;
    NSArray *trackListsArray;
    NSDictionary *trackInfo;
    PendingView *pendingView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *trackMode;
@property (nonatomic, retain) NSArray *trackListsArray;
@property (nonatomic, retain) NSDictionary *trackInfo;
@property (nonatomic, retain) PendingView *pendingView;

- (void)trackListsUpdate;

- (void)showPendingView;
- (void)hidePendingView;

@end
