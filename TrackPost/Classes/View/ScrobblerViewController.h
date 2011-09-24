//
//  ScrobblerViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 04/17/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface ScrobblerViewController : UIViewController <ADBannerViewDelegate> {
    IBOutlet UILabel *artistNameLabel;
    IBOutlet UILabel *trackNameLabel;
    IBOutlet UILabel *waitingForiPodLabel;
    IBOutlet UILabel *tagsLabel;
    IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *scrobbleButton;
    IBOutlet UIButton *loveButton;
    ADBannerView *adView;
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
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *scrobbleButton;
@property (nonatomic, retain) UIButton *loveButton;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL lovedTrack;

@property (nonatomic, retain) UIImageView *trackImageView;

@property (nonatomic, retain) UITextView *tagTextView;

@property (nonatomic, retain) NSDictionary *trackInfo;

@property (nonatomic, retain) NSArray *tagArray;

- (void)logoutButtonPressed:(id)sender;
- (void)logoutAction;

- (void)refreshCurrentTracks;

@end
