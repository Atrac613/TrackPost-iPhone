//
//  RightViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/15/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingView.h"

@interface RightViewController : UIViewController {
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
    IBOutlet UIButton *button10;
    IBOutlet UIButton *button11;
    IBOutlet UIButton *button12;
    IBOutlet UIButton *button13;
    IBOutlet UIButton *button14;
    IBOutlet UIButton *button15;
    IBOutlet UIButton *button16;
    IBOutlet UIButton *button17;
    IBOutlet UIButton *button18;
    IBOutlet UIButton *button19;
    IBOutlet UIButton *button20;
    
    NSArray *lovedTracksArray;
    NSMutableArray *rankArray;
    
    NSDictionary *trackInfo;
    PendingView *pendingView;
}

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;
@property (nonatomic, retain) IBOutlet UIButton *button6;
@property (nonatomic, retain) IBOutlet UIButton *button7;
@property (nonatomic, retain) IBOutlet UIButton *button8;
@property (nonatomic, retain) IBOutlet UIButton *button9;
@property (nonatomic, retain) IBOutlet UIButton *button10;
@property (nonatomic, retain) IBOutlet UIButton *button11;
@property (nonatomic, retain) IBOutlet UIButton *button12;
@property (nonatomic, retain) IBOutlet UIButton *button13;
@property (nonatomic, retain) IBOutlet UIButton *button14;
@property (nonatomic, retain) IBOutlet UIButton *button15;
@property (nonatomic, retain) IBOutlet UIButton *button16;
@property (nonatomic, retain) IBOutlet UIButton *button17;
@property (nonatomic, retain) IBOutlet UIButton *button18;
@property (nonatomic, retain) IBOutlet UIButton *button19;
@property (nonatomic, retain) IBOutlet UIButton *button20;

@property (nonatomic, retain) NSArray *lovedTracksArray;
@property (nonatomic, retain) NSMutableArray *rankArray;

@property (nonatomic, retain) NSDictionary *trackInfo;
@property (nonatomic, retain) PendingView *pendingView;

- (void)button1Pressed;
- (void)button2Pressed;
- (void)button3Pressed;
- (void)button4Pressed;
- (void)button5Pressed;
- (void)button6Pressed;
- (void)button7Pressed;
- (void)button8Pressed;
- (void)button9Pressed;
- (void)button10Pressed;
- (void)button11Pressed;
- (void)button12Pressed;
- (void)button13Pressed;
- (void)button14Pressed;
- (void)button15Pressed;
- (void)button16Pressed;
- (void)button17Pressed;
- (void)button18Pressed;
- (void)button19Pressed;
- (void)button20Pressed;

- (void)getTrackInfo:(NSArray*)object;


- (void)showPendingView;
- (void)hidePendingView;

@end
