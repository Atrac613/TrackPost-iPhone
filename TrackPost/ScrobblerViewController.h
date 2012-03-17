//
//  ScrobblerViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/17/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface ScrobblerViewController : UIViewController <ADBannerViewDelegate> {
    IBOutlet UILabel *artistNameLabel;
    IBOutlet UILabel *trackNameLabel;
    IBOutlet UILabel *waitingForiPodLabel;
    IBOutlet UILabel *tagsLabel;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *scrobbleButton;
    IBOutlet UIButton *loveButton;
    IBOutlet ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL isPlaying;
    BOOL lovedTrack;
    
    IBOutlet UIImageView *trackImageView;
    IBOutlet UITextView *tagTextView;
    NSDictionary *trackInfo;
    NSArray *tagArray;
}

@property (nonatomic, retain) UILabel *artistNameLabel;
@property (nonatomic, retain) UILabel *trackNameLabel;
@property (nonatomic, retain) UILabel *waitingForiPodLabel;
@property (nonatomic, retain) UILabel *tagsLabel;
@property (nonatomic, retain) UIButton *shareButton;
@property (nonatomic, retain) UIButton *scrobbleButton;
@property (nonatomic, retain) UIButton *loveButton;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL lovedTrack;

@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (nonatomic, retain) UIImageView *trackImageView;

@property (nonatomic, retain) UITextView *tagTextView;

@property (nonatomic, retain) NSDictionary *trackInfo;

@property (nonatomic, retain) NSArray *tagArray;

- (IBAction)shareButtonPressed:(id)sender;
- (void)refreshCurrentTracks;

@end
