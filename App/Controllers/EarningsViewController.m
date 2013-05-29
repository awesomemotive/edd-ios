//
//  EarningsViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/17/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "EarningsViewController.h"

#import "EarningsDetailViewController.h"
#import "UIColor+Helpers.h"
#import "UIView+ViewHelper.h"

@interface EarningsViewController () {
	NSArray *items;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

@implementation EarningsViewController {
	
@private
	float earnings;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.title = NSLocalizedString(@"Earnings", nil);
		
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
	items = [NSArray arrayWithObjects:@"Today", @"Yesterday", @"This Month", @"Last Month", @"This Quarter", @"Last Quarter", @"This Year", @"Last Year", @"Custom", nil];
	
    [self.view disableScrollsToTopPropertyOnMeAndAllSubviews];
    self.tableView.scrollsToTop = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
			
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *range = [items objectAtIndex:indexPath.row];
	EarningsDetailViewController *detailViewController = [[EarningsDetailViewController alloc] initWithRange:range];	
    [self.navigationController pushViewController:detailViewController animated:YES];	
}

@end
