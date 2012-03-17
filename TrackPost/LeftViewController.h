//
//  LeftViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *userNameLabel;
    
    NSDictionary *userProfileDictionary;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;

@property (nonatomic, retain) NSDictionary *userProfileDictionary;

@end
