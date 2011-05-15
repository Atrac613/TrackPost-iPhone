//
//  TrackCell.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/18.
//  Copyright 2011 envision. All rights reserved.
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
