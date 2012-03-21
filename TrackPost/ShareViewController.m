//
//  ShareViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/20/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize tableView;
@synthesize navigationBar;
@synthesize navigationItem;
@synthesize toolBar;
@synthesize pendingView;
@synthesize doTweet;
@synthesize doFacebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
	
    [self.navigationItem setTitle:NSLocalizedString(@"SHARE", @"")];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancelButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed {

}

- (void)keyboardChanged:(NSNotification*)notification {
    // Remove toolbar
    [toolBar removeFromSuperview];
    
    // Get KeyBoard CGRect.
    NSDictionary *info = [notification userInfo];
    NSValue *keyValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    
    NSInteger toolBarY = self.view.frame.size.height - keyboardSize.height - 40;

    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 40)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeButtonPressed)];
    [toolBar setItems:[[NSArray alloc] initWithObjects:flexibleSpace, closeButton,nil]];
    [toolBar setAlpha:0.9f];
    
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [toolBar setFrame:CGRectMake(0, toolBarY, 320, 40)];
    
    [UIView commitAnimations];
}

- (void)closeButtonPressed {
    UITextView *textView = (UITextView*)[self.view viewWithTag:1001];
    [textView resignFirstResponder];
    
    [toolBar removeFromSuperview];
}


#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return 2;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70.f;
        }
    }
    
    return 40.f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"MESSAGE", @"");
    } else {
        return NSLocalizedString(@"SHARING", @"");
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return  @"";
}

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 300, 65)];
            [textView setTag:1001];
            [textView setBackgroundColor:[UIColor clearColor]];
            
            [cell addSubview:textView];
        }
    } else if (indexPath.section == 1) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"twitter_icon.jpg"];
            imageView.layer.cornerRadius = 5.f;
            imageView.clipsToBounds = YES;
            imageView.frame = CGRectMake(15, 6, 30, 30);
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 30)];
            label.text = NSLocalizedString(@"TWITTER", @"");
            label.backgroundColor = [UIColor clearColor];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = 11001;
            cell.accessoryView = switchView;
            
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:label];
        } else {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"facebook_icon.jpg"];
            imageView.layer.cornerRadius = 5.f;
            imageView.clipsToBounds = YES;
            imageView.frame = CGRectMake(15, 5, 30, 30);
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 30)];
            label.text = NSLocalizedString(@"FACEBOOK", @"");
            label.backgroundColor = [UIColor clearColor];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = 11002;
            cell.accessoryView = switchView;
            
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:label];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog(@"Tweet is %@", switchControl.on ? @"ON" : @"OFF");
    
    if (switchControl.tag == 11001) {
        doTweet = switchControl.on;
    } else {
        doFacebook = switchControl.on;
        
        if (doFacebook) {
            /*
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            appDelegate.facebook = [[Facebook alloc] initWithAppId:@"132918306826766" andDelegate:self];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] 
                && [defaults objectForKey:@"FBExpirationDateKey"]) {
                appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            
            if (![appDelegate.facebook isSessionValid]) {
                NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", @"offline_access",nil];
                [appDelegate.facebook authorize:permissions];
            }*/
        }
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    return YES;
}

- (void)showPendingView {
    if (pendingView == nil && ![self.view.subviews containsObject:pendingView]) {
        pendingView = [[PendingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
        pendingView.titleLabel.text = NSLocalizedString(@"PLEASE_WAIT", @"Please wait");
        pendingView.userInteractionEnabled = YES;
        [self.view addSubview:pendingView];
    }
    
    [pendingView showPendingView];
}

- (void)hidePendingView {
    if ([self.view.subviews containsObject:pendingView]) {
        [pendingView hidePendingView];
        
        pendingView = nil;
    }
}

@end
