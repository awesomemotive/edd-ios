//
//  MainViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "EDDAPIClient.h"
#import "MainViewController.h"
#import "NSString+DateHelper.h"
#import "NVSlideMenuController.h"
#import "SettingsHelper.h"
#import "SetupViewController.h"
#import "SVProgressHUD.h"
#import "UIColor+Helpers.h"

@interface MainViewController () {
	SetupViewController *setupViewController;
	BOOL setupIsPresent;
}

- (void)reload:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *salesButton;
@property (nonatomic, retain) IBOutlet UILabel *siteName;

- (IBAction)salesButtonTapped:(id)sender;

@end

@implementation MainViewController {
	
@private
	float currentMonthlyEarnings;
	float alltimeEarnings;
}


- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
	
	[self setupNotifications];
	
	return self;
}

- (void)reload:(id)sender {
	[SVProgressHUD showWithStatus:@"Loading Data..." maskType:SVProgressHUDMaskTypeClear];
    self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self loadEarningsReport];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-brand"]];
	
	self.title = NSLocalizedString(@"Home", nil);
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
	[self setupSiteName];
	
	if ([SettingsHelper requiresSetup]) {
//	if (YES) { // for testing
		[self showSetup];
		setupIsPresent = YES;
	} else {
		[self reload:nil];
	}
}

- (void)setupSiteName {
	NSString *siteName = [SettingsHelper getSiteName];
	self.siteName.text = siteName;
	self.siteName.hidden = [NSString isNullOrWhiteSpace:siteName];
}

- (void)loadEarningsReport {
	NSDictionary *params = [EDDAPIClient defaultParams];
	[params setValue:@"earnings" forKey:@"type"];
	[[EDDAPIClient sharedClient] getPath:@"stats/" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
		NSDictionary *earningsFromResponse = [JSON valueForKeyPath:@"earnings"];
		currentMonthlyEarnings = [[earningsFromResponse objectForKey:@"current_month"] floatValue];
		alltimeEarnings = [[earningsFromResponse objectForKey:@"totals"] floatValue];
		
		
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.tableView reloadData];
		[SVProgressHUD dismiss];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.localizedDescription];		
	}];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(setupDismissalRequested:) name:@"SettingsInitialSetup" object: nil];
}

- (void)showSetup {
	setupViewController = [[SetupViewController alloc] initForInitialSetup];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setupViewController];
	[self presentViewController:nav animated:YES completion:nil];
}

- (void)setupDismissalRequested:(NSNotification *) notification {
	[self setupSiteName];
	[self dismissViewControllerAnimated:YES completion:nil];
	setupIsPresent = NO;
	[self reload:nil];
}

- (BOOL)shouldAutorotate {
	return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		cell.textLabel.text = @"Earnings";
		cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		
		return cell;
	}
	
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#009100"];
    
    // Configure the cell...
	
	float earnings = 0.0f;
	
	switch (indexPath.row) {
		case 1:
			earnings = currentMonthlyEarnings;
			break;
		case 2:
			earnings = alltimeEarnings;
			break;
	}
	
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[currencyFormatter setCurrencyCode:[SettingsHelper getCurrency]];
		
	cell.textLabel.text = indexPath.row == 1 ? @"Current Month:" : @"All-Time:";
	cell.detailTextLabel.text = [currencyFormatter stringFromNumber: [NSNumber numberWithFloat:earnings]];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBActions

- (IBAction)salesButtonTapped:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRecentSales" object:self];	
}

@end
