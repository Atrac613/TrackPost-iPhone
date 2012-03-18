//
//  ThirdPartyNoticesViewController.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/18/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdPartyNoticesViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
