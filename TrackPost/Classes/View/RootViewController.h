//
//  RootViewController.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/17.
//  Copyright 2011 envision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *loginButton;
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;

@end
