//
//  LoginViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/17/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LastFMService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tableView;
@synthesize navigationBar;
@synthesize navigationItem;
@synthesize pendingView;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(loginButtonPressed)];
	
    [self.navigationItem setTitle:NSLocalizedString(@"LOGIN", @"")];
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

- (void)loginButtonPressed {
    UITextField *usernameField = (UITextField*)[self.view viewWithTag:100];
    UITextField *passwordField = (UITextField*)[self.view viewWithTag:101];
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    [self showPendingView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronizeLoginAction) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
    [appDelegate.operationQueue addOperation:operation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"LASTFM_ACCOUNT", @"");
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 30)];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 150, 30)];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = [indexPath row] + 100;
        
        if (indexPath.row == 0) {
            label.text = @"Username";
            textField.placeholder = NSLocalizedString(@"USERNAME", @"");
            
        } else {
            label.text = @"Password";
            textField.placeholder = NSLocalizedString(@"PASSWORD", @"");
            textField.secureTextEntry = YES;
        }
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:textField];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)synchronizeLoginAction {
    UITextField *usernameField = (UITextField*)[self.view viewWithTag:100];
    UITextField *passwordField = (UITextField*)[self.view viewWithTag:101];
    
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    NSLog(@"Username: %@, Password: %@", username, password);
    
    NSDictionary *session = [[LastFMService sharedInstance] getMobileSessionForUser:username password:password];
    NSLog(@"%@", session);
    if([[session objectForKey:@"key"] length]) {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"lastfm_user"];
        [[NSUserDefaults standardUserDefaults] setObject:[session objectForKey:@"key"] forKey:@"lastfm_session"];
        [[NSUserDefaults standardUserDefaults] setObject:[session objectForKey:@"subscriber"] forKey:@"lastfm_subscriber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Login Success");
	}
    
    [self performSelectorOnMainThread:@selector(completeLoginAction:) withObject:[LastFMService sharedInstance].error waitUntilDone:YES];
}

- (void)completeLoginAction:(NSError*)error {
    NSLog(@"completeLoginAction");
    
    NSLog(@"code %d", [error code]);
    NSLog(@"domain %@", [error domain]);
    NSLog(@"desc %@", [error localizedDescription]);
    
    [self hidePendingView];
    
    if ([error code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AUTH_ERROR_TITLE", @"Auth error title")
                                                        message:NSLocalizedString([error localizedDescription], @"error")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"ok")
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)showPendingView {
    if (pendingView == nil && ![self.view.subviews containsObject:pendingView]) {
        pendingView = [[PendingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
        pendingView.titleLabel.text = NSLocalizedString(@"PLEASE_WAIT", @"Please wait");
        pendingView.userInteractionEnabled = NO;
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
