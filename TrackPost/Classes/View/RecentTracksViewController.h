//
//  RecentTracksViewController.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/18.
//  Copyright 2011 envision. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentTracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSArray *recentTracksArray;
    NSDictionary *trackInfo;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *recentTracksArray;
@property (nonatomic, retain) NSDictionary *trackInfo;

- (void)recentTracksUpdate;

@end
