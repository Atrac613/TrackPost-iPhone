//
//  FullScreenPendingView.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenPendingView : UIView {
    UIView *pendingView;
    UIView *maskView;
    UILabel *titleLabel;
    UIActivityIndicatorView *indicatorView;
    UIProgressView *progressView;
    BOOL pendingViewEnabled;
}

@property (nonatomic, retain) UIView *pendingView;
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, assign) BOOL pendingViewEnabled;

-(void)showPendingView;
-(void)hidePendingView;
-(void)removePendingView;

@end
