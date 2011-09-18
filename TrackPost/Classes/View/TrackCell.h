//
//  TrackCell.h
//  TrackPost
//
//  Created by Osamu Noguchi on 04/18/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackCell : UITableViewCell {
    UILabel *artistNameLabel;
    UILabel *trackNameLabel;
    UILabel *dateLabel;
}

@property (nonatomic, retain) UILabel *artistNameLabel;
@property (nonatomic, retain) UILabel *trackNameLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@end
