//
//  FullScreenPendingView.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "FullScreenPendingView.h"

@implementation FullScreenPendingView

@synthesize pendingView;
@synthesize maskView;
@synthesize titleLabel;
@synthesize indicatorView;
@synthesize progressView;
@synthesize pendingViewEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pendingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
        [self addSubview:pendingView];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.0f];
        [pendingView addSubview:maskView];
        
        indicatorView = [[UIActivityIndicatorView alloc] init];
        [indicatorView setFrame:CGRectMake(85,60,20,20)];
        [indicatorView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView setHidesWhenStopped:YES];
        [indicatorView setAlpha:0.0f];
        [self addSubview:indicatorView];
        [indicatorView stopAnimating];
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 160, 150, 10)];
        [progressView setProgress:0];
        [progressView setHidden:YES];
        [progressView setAlpha:0.5f];
        [pendingView addSubview:progressView];
    }
    return self;
}

- (void)showPendingView {
    if (!pendingViewEnabled) {
        pendingViewEnabled = YES;
        
        [indicatorView startAnimating];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [indicatorView setAlpha:1.f];
        
        [maskView setAlpha:0.8f];
        
        [UIView commitAnimations];
    }
}

- (void)hidePendingView {
    if (pendingViewEnabled) {
        pendingViewEnabled = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [indicatorView setAlpha:0.0f];
        [pendingView setAlpha:0.0f];
        
        [UIView commitAnimations];
        
        [indicatorView stopAnimating];
        
        [self performSelector:@selector(removePendingView) withObject:nil afterDelay:0.4];
    }
}

-(void)removePendingView {
    [indicatorView stopAnimating];
    [self removeFromSuperview];
}

@end
