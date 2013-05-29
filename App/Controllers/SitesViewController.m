//
//  SitesViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 5/28/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "SitesViewController.h"

#import "SettingsHelper.h"
#import "SetupViewController.h"
#import "UIColor+Helpers.h"
#import "UIView+ViewHelper.h"

@interface SitesViewController ()

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

@implementation SitesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.title = NSLocalizedString(@"Site Setup", nil);
	
	[self setupNewButton];
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
    [self.view disableScrollsToTopPropertyOnMeAndAllSubviews];
    self.tableView.scrollsToTop = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)setupNewButton {
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newSite)];
	self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)newSite {
	[self selectSite:nil];
}

- (void)selectSite:(NSDictionary *)site {
	SetupViewController *setupViewController = [[SetupViewController alloc] initForSiteCreation:site];
    [self.navigationController pushViewController:setupViewController animated:YES];	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self siteCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	
	NSDictionary *site = [self getSite:indexPath.row];
	
	cell.textLabel.text = [site objectForKey:KEY_FOR_SITE_NAME];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

- (int)siteCount {
	return [[[SettingsHelper getSites] allKeys] count];
}

- (NSDictionary *)getSite:(int)index {
	NSArray *keys = [[SettingsHelper getSites] allKeys];
	id aKey = [keys objectAtIndex:index];
	NSDictionary *site = [[SettingsHelper getSites] objectForKey:aKey];
	return site;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *site = [self getSite:indexPath.row];
	[self selectSite:site];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([self siteCount] > 1) {
			
			NSDictionary *site = [self getSite:indexPath.row];
			[SettingsHelper removeSite:site];
			
			if ([[SettingsHelper getCurrentSiteID] isEqualToString:[site objectForKey:KEY_FOR_SITE_ID]]) {
				NSDictionary *newCurrentSite = [self getSite:0];
				[SettingsHelper setCurrentSiteID:[newCurrentSite objectForKey:KEY_FOR_SITE_ID]];
			}
			
			// delete site and reload table data
			[self.tableView reloadData];
			
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must have at least one site" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
	}
}

@end
