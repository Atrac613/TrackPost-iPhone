//
//  TrackInfoViewController.h
//  TrackPost
//
//  Created by Noguchi Osamu on 11/04/21.
//  Copyright 2011 envision. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackInfoViewController : UIViewController {
    IBOutlet UILabel *trackNameLabel;
    IBOutlet UILabel *artistNameLabel;
    
    IBOutlet UILabel *listenersLabel;
    IBOutlet UILabel *playcountLabel;
    IBOutlet UILabel *userplaycountLabel;
    
    IBOutlet UIImageView *trackImageView;
    
    IBOutlet UIButton *loveButton;
    
    IBOutlet UITextView *tagTextView;
    
    NSDictionary *trackInfo;
    NSArray *tagArray;
    BOOL lovedTrack;
}

@property (nonatomic, retain) UILabel *trackNameLabel;
@property (nonatomic, retain) UILabel *artistNameLabel;

@property (nonatomic, retain) UILabel *listenersLabel;
@property (nonatomic, retain) UILabel *playcountLabel;
@property (nonatomic, retain) UILabel *userplaycountLabel;

@property (nonatomic, retain) UIImageView *trackImageView;
@property (nonatomic, retain) UIButton *loveButton;

@property (nonatomic, retain) UITextView *tagTextView;

@property (nonatomic, retain) NSDictionary *trackInfo;

@property (nonatomic, retain) NSArray *tagArray;

@property (nonatomic, assign) BOOL lovedTrack;

@end
