//
//  AboutViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface AboutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    PendingView *pendingView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PendingView *pendingView;

- (void)showPendingView;
- (void)hidePendingView;

@end
