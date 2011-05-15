//
//  ScrobblerViewController.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>

@interface ScrobblerViewController : UIViewController <ADBannerViewDelegate> {
    IBOutlet UILabel *artistNameLabel;
    IBOutlet UILabel *trackNameLabel;
    //IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *scrobblerButton;
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
//@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *scrobblerButton;
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

-(void)refreshCurrentTracks;

@end
