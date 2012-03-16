//
//  PendingView.m
//  kesikesi
//
//  Created by Osamu Noguchi on 05/07/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import "PendingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PendingView

@synthesize pendingView;
@synthesize maskView;
@synthesize titleLabel;
@synthesize indicatorView;
@synthesize pendingViewEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //NSLog(@"Center: %f, %f", (self.frame.size.width/2), (self.frame.size.height/2));
        
        pendingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        [pendingView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2-30)];
        [self addSubview:pendingView];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.0f];
        [maskView.layer setCornerRadius:20.f];
        [maskView setClipsToBounds:YES];
        [pendingView addSubview:maskView];
        
        indicatorView = [[UIActivityIndicatorView alloc] init];
        [indicatorView setFrame:CGRectMake(85,60,80,80)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setHidesWhenStopped:YES];
        [pendingView addSubview:indicatorView];
        [indicatorView startAnimating];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 250, 33)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:27]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Now Loading..."];
        [pendingView addSubview:titleLabel];
    }
    return self;
}

- (void)showPendingView {
    if (!pendingViewEnabled) {
        pendingViewEnabled = YES;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [maskView setAlpha:0.5f];
        pendingView.transform = CGAffineTransformScale(pendingView.transform, 0.6, 0.6);
        
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
        
        [pendingView setAlpha:0.0f];
        pendingView.transform = CGAffineTransformScale(pendingView.transform, 0.1, 0.1);
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(removePendingView) withObject:nil afterDelay:0.4];
    }
}

-(void)removePendingView {
    //NSLog(@"removePendingView");
    [indicatorView stopAnimating];
    [self removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
