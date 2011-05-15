//
//  TrackCell.m
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/18.
//  Copyright 2011 envision. All rights reserved.
//

#import "TrackCell.h"


@implementation TrackCell

@synthesize artistNameLabel;
@synthesize trackNameLabel;
@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        artistNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 230, 14)] autorelease];
        [artistNameLabel setFont:[UIFont systemFontOfSize:13]];
        [artistNameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:artistNameLabel];
        
        trackNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 170, 19)] autorelease];
        [trackNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [trackNameLabel setTextColor:[UIColor blackColor]];
        [self addSubview:trackNameLabel];
        
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(190, 5, 120, 14)] autorelease];
        [dateLabel setFont:[UIFont systemFontOfSize:13]];
        [dateLabel setTextColor:[UIColor blackColor]];
        [dateLabel setAdjustsFontSizeToFitWidth:YES];
        [dateLabel setTextAlignment:UITextAlignmentRight];
        [self addSubview:dateLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
