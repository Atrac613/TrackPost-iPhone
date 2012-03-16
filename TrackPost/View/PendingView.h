//
//  PendingView.h
//  kesikesi
//
//  Created by Osamu Noguchi on 05/07/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PendingView : UIView {
    UIView *pendingView;
    UIView *maskView;
    UILabel *titleLabel;
    UIActivityIndicatorView *indicatorView;
    BOOL pendingViewEnabled;
}

@property (nonatomic, retain) UIView *pendingView;
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL pendingViewEnabled;

-(void)showPendingView;
-(void)hidePendingView;
-(void)removePendingView;

@end
