//
//  RootViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 04/17/11.
//  Copyright 2011 atrac613.io All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface RootViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *loginButton;
    
    PendingView *pendingView;
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;

@property (nonatomic, retain) PendingView *pendingView;

- (void)showPendingView;
- (void)hidePendingView;

@end
