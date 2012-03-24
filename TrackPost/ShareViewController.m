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
@synthesize artistName;
@synthesize trackName;
@synthesize lastfmPage;
@synthesize shareMessage;
@synthesize shareMessageMinimum;
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
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
	
    [self.navigationItem setTitle:NSLocalizedString(@"SHARE", @"")];
    
    SharedAppDelegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_KEY_APP_ID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:FACEBOOK_KEY_ACCESS_TOKEN] 
        && [defaults objectForKey:FACEBOOK_KEY_EXPIRATION_DATE]) {
        SharedAppDelegate.facebook.accessToken = [defaults objectForKey:FACEBOOK_KEY_ACCESS_TOKEN];
        SharedAppDelegate.facebook.expirationDate = [defaults objectForKey:FACEBOOK_KEY_EXPIRATION_DATE];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
    
    NSString *shareTitle = [[NSUserDefaults standardUserDefaults] objectForKey:OPTION_KEY_SHARE_TITLE];
    if ([shareTitle length] <= 0) {
        shareTitle = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"NOW_PLAYING", @"")];
    }
    
    BOOL prefixEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:OPTION_KEY_SHARE_PREFIX];
    BOOL suffixEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:OPTION_KEY_SHARE_SUFFIX];
    BOOL addLastfmPageEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:OPTION_KEY_SHARE_ADD_LASTFM_PAGE];
    
    shareMessage = [NSString stringWithFormat:@"%@ - %@", artistName, trackName];
    
    if (prefixEnabled) {
        shareMessage = [NSString stringWithFormat:@"%@ %@", shareTitle, shareMessage];
    }
    
    if (suffixEnabled) {
        shareMessage = [NSString stringWithFormat:@"%@ %@", shareMessage, shareTitle];
    }
    
    shareMessageMinimum = shareMessage;
    
    if (addLastfmPageEnabled) {
        if ([lastfmPage length] > 0) {
            shareMessage = [NSString stringWithFormat:@"%@ %@", shareMessage, lastfmPage];
        }
    }
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
    [self showPendingView];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationSendTwitter) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [SharedAppDelegate.operationQueue addOperation:operation];
}

- (void)operationSendTwitter {
    NSLog(@"operationSendTwitter");
    
    if (doTweet) {
        [self sendTwitter:shareMessage];
    } else {
        [self performSelectorOnMainThread:@selector(operationSendFacebook) withObject:nil waitUntilDone:YES];
    }
}

- (void)operationSendFacebook {
    NSLog(@"operationSendFacebook");
    
    if (doFacebook) {
        [self sendFacebook:shareMessageMinimum url:lastfmPage];
    } else {
        NSLog(@"Completed.");
        
        [self dismissModalViewControllerAnimated:YES];
    }
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
            
            [textView setText:shareMessage];
            
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
            label.font = [UIFont boldSystemFontOfSize:18];
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
            label.font = [UIFont boldSystemFontOfSize:18];
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
    NSLog(@"Switch is %@", switchControl.on ? @"ON" : @"OFF");
    
    if (switchControl.tag == 11001) {
        doTweet = switchControl.on;
    } else {
        doFacebook = switchControl.on;
        
        if (doFacebook) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if (![appDelegate.facebook isSessionValid]) {
                NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", @"offline_access",nil];
                [appDelegate.facebook authorize:permissions];
            }
        }
    }
    
    if (doFacebook || doTweet) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    return YES;
}

- (void)sendTwitter:(NSString *)message {
    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
			// Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			// For the sake of brevity, we'll assume there is only one Twitter account present.
			// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
			if ([accountsArray count] > 0) {
				// Grab the initial Twitter account to tweet from.
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
				
				// Create a request, which in this example, posts a tweet to the user's timeline.
				// This example uses version 1 of the Twitter API.
				// This may need to be changed to whichever version is currently appropriate.
				TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:message forKey:@"status"] requestMethod:TWRequestMethodPOST];
				
				// Set the account used to post the tweet.
				[postRequest setAccount:twitterAccount];
				
				// Perform the request created above and create a handler block to handle the response.
				[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
					NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
					
                    [self performSelectorOnMainThread:@selector(operationSendFacebook) withObject:nil waitUntilDone:YES];
				}];
			}
        }
	}];
}

- (void)sendFacebook:(NSString *)message url:(NSString*)url {
    if ([SharedAppDelegate.facebook isSessionValid]) {
        if ([url length] > 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: url, @"link", message, @"message", nil];
            
            [SharedAppDelegate.facebook requestWithGraphPath:@"me/links" andParams:params andHttpMethod:@"POST" andDelegate:self];
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: message, @"message", nil];
            
            [SharedAppDelegate.facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
    } else {
        NSLog(@"Facebook session is invalid.");
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - Facebook delegate

- (void)fbDidLogin {
    NSLog(@"fbDidLogin");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[SharedAppDelegate.facebook accessToken] forKey:FACEBOOK_KEY_ACCESS_TOKEN];
    [defaults setObject:[SharedAppDelegate.facebook expirationDate] forKey:FACEBOOK_KEY_EXPIRATION_DATE];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"fbDidNotLogin");
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"request didReceiveResponse");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"request didLoad");
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    
    [self dismissModalViewControllerAnimated:YES];
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
