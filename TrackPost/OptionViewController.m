//
//  OptionViewController.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/23/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "OptionViewController.h"
#import "IIViewDeckController.h"

@interface OptionViewController ()

@end

@implementation OptionViewController

@synthesize tableView;

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
    
	[self.navigationItem setTitle:NSLocalizedString(@"OPTION", @"")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
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


#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"SHARE_OPTION", @"");
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
        
        if (indexPath.row == 0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 280, 25)];
            [textField setDelegate:self];
            
            NSString *titleString = [[NSUserDefaults standardUserDefaults] objectForKey:@"share_title"];
            if ([titleString length] <= 0) {
                titleString = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"NOW_PLAYING", @"")];
            }
            
            [textField setText:titleString];
            [cell.contentView addSubview:textField];
        } else if (indexPath.row == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 100, 30)];
            label.text = NSLocalizedString(@"PREFIX", @"");
            label.font = [UIFont boldSystemFontOfSize:18];
            label.backgroundColor = [UIColor clearColor];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = 11001;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"share_prefix"];
            cell.accessoryView = switchView;
            
            //[switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:label];
        } else if (indexPath.row == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 100, 30)];
            label.text = NSLocalizedString(@"SUFFIX", @"");
            label.font = [UIFont boldSystemFontOfSize:18];
            label.backgroundColor = [UIColor clearColor];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = 11002;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"share_suffix"];
            cell.accessoryView = switchView;
            
            //[switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:label];
        } else if (indexPath.row == 3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 200, 30)];
            label.text = NSLocalizedString(@"ADD_LASTFM_PAGE", @"");
            label.font = [UIFont boldSystemFontOfSize:18];
            label.backgroundColor = [UIColor clearColor];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchView.tag = 11003;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"share_add_lastfm_page"];
            cell.accessoryView = switchView;
            
            //[switchView setOn:NO animated:NO];
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
        [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"share_prefix"];
    } else if (switchControl.tag == 11002) {
        [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"share_suffix"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"share_add_lastfm_page"];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"share_title"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
