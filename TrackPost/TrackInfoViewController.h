//
//  TrackInfoViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackInfoViewController : UIViewController {
    IBOutlet UILabel *trackNameLabel;
    IBOutlet UILabel *artistNameLabel;
    
    IBOutlet UILabel *listenersTitleLabel;
    IBOutlet UILabel *playcountTitleLabel;
    IBOutlet UILabel *userplaycountTitleLabel;
    IBOutlet UILabel *tagsTitleLabel;
    
    IBOutlet UIImageView *trackImageView;
    
    IBOutlet UIButton *loveButton;
    
    IBOutlet UITextView *tagTextView;
    
    NSDictionary *trackInfo;
    NSArray *tagArray;
    BOOL lovedTrack;
    
    BOOL enabledBackButton;
}

@property (nonatomic, retain) UILabel *trackNameLabel;
@property (nonatomic, retain) UILabel *artistNameLabel;

@property (nonatomic, retain) UILabel *listenersTitleLabel;
@property (nonatomic, retain) UILabel *playcountTitleLabel;
@property (nonatomic, retain) UILabel *userplaycountTitleLabel;
@property (nonatomic, retain) UILabel *tagsTitleLabel;

@property (nonatomic, retain) UIImageView *trackImageView;
@property (nonatomic, retain) UIButton *loveButton;

@property (nonatomic, retain) UITextView *tagTextView;

@property (nonatomic, retain) NSDictionary *trackInfo;

@property (nonatomic, retain) NSArray *tagArray;

@property (nonatomic, assign) BOOL lovedTrack;
@property (nonatomic, assign) BOOL enabledBackButton;

@end
