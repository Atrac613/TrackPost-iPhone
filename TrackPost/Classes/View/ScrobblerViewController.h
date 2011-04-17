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
}

@property (nonatomic, retain) UILabel *artistNameLabel;
@property (nonatomic, retain) UILabel *trackNameLabel;
//@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *scrobblerButton;
@property (nonatomic, retain) UIButton *loveButton;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (void)logoutButtonPressed:(id)sender;
- (void)logoutAction;

@end
