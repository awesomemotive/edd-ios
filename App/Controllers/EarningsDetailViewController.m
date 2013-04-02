//
//  EarningsDetailViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/19/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "EarningsDetailViewController.h"

#import "EDDAPIClient.h"
#import "SVProgressHUD.h"
#import "UIColor+Helpers.h"
#import "TDSemiModal.h"
#import "TDDatePickerController.h"
#import "SettingsHelper.h"

@interface EarningsDetailViewController () {
	TDDatePickerController *_datePickerView;
	BOOL _selectingStartDate;
	BOOL _selectingEndDate;
}

- (void)reload:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *loadCustomButton;

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *currentChoice;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSString *range;

- (IBAction)loadCustom:(id)sender;

@end

@implementation EarningsDetailViewController {
	
@private
	float earnings;
}

@synthesize items = _items;
@synthesize currentChoice = _currentChoice;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize range = _range;

- (id)initWithRange:(NSString *)range {
    self = [super init];
    if (!self) {
        return nil;
    }
	
	_range = range;
	
	return self;
}

- (void)reload:(id)sender {
	[SVProgressHUD showWithStatus:@"Loading Earnings..." maskType:SVProgressHUDMaskTypeClear];
    self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self loadEarningsReport];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(datePickerDisplayChanged:)
                                                 name:@"DatePickerDisplayChangedNotification"
                                               object:nil];
   
    self.title = NSLocalizedString(@"Earnings", nil);
	
    self.navigationItem.leftBarButtonItem = nil;
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];

	self.loadCustomButton.hidden = YES;
	
	self.currentChoice = [self retrieveChoice:_range];
	
	[self handleCustom];
	
	if (![self isCustom]) {
		[self reload:nil];
	}
}

- (void)loadEarningsReport {
	NSDictionary *params = [EDDAPIClient defaultParams];
	[params setValue:@"earnings" forKey:@"type"];
	
	if ([self isCustom]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyyMMdd"];
		
		[params setValue:@"range" forKey:@"date"];
		[params setValue:[dateFormatter stringFromDate:self.endDate] forKey:@"enddate"];
		[params setValue:[dateFormatter stringFromDate:self.startDate] forKey:@"startdate"];
	} else {
		[params setValue:self.currentChoice forKey:@"date"];
	}
	
	[[EDDAPIClient sharedClient] getPath:@"stats/" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
		NSDictionary *earningsFromResponse = [JSON valueForKeyPath:@"earnings"];
		earnings = 0;
		
		if ([self isCustom]) {
			for (id earning in earningsFromResponse) {
				float value = [[earningsFromResponse objectForKey:earning] floatValue];
				earnings = value + earnings;
			}
		} else if ([earningsFromResponse objectForKey:self.currentChoice]) {
			earnings = [[earningsFromResponse objectForKey:self.currentChoice] floatValue];
		}
		
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.tableView reloadData];
		[SVProgressHUD dismiss];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.localizedDescription];
		NSLog(@"%@", error);
	}];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.loadCustomButton.hidden ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.loadCustomButton.hidden) return 1;
	
	return section == 0 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	
	if (indexPath.section == 0) {
		NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter setCurrencyCode:[SettingsHelper getCurrency]];
		
		cell.textLabel.text = _range;
		cell.detailTextLabel.text = [currencyFormatter stringFromNumber: [NSNumber numberWithFloat:earnings]];
		cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#009100"];
		
	} else {
		cell.textLabel.text = indexPath.row == 0 ? @"Start Date" : @"End Date";
		NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"MM/dd/yyyy"];
		NSString *timeString = [timeFormatter stringFromDate:indexPath.row == 0 ? self.startDate : self.endDate];
		cell.detailTextLabel.text = timeString;
		cell.detailTextLabel.textColor = [UIColor blackColor];
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) return;
	
	if (indexPath.row == 0) {
		[self handleStartDateSelection];
	} else {
		[self handleEndDateSelection];
	}
}

- (void)handleStartDateSelection {
	_selectingStartDate = YES;
	_selectingEndDate = NO;
	
	_datePickerView = [[TDDatePickerController alloc] init];
	_datePickerView.delegate = self;
	
	[self presentSemiModalViewController:_datePickerView];
}

- (void)handleEndDateSelection {
	_selectingStartDate = NO;
	_selectingEndDate = YES;
	
	_datePickerView = [[TDDatePickerController alloc] init];
	_datePickerView.delegate = self;
	
	[self presentSemiModalViewController:_datePickerView];
}

#pragma mark - IBActions

- (IBAction)loadCustom:(id)sender {
	if (self.startDate == nil || self.endDate == nil) {
		return;
	}
	
	[self reload:nil];
}

#pragma mark - Choices

// Today, Yesterday, This Month, Last Month, This Quarter, Last Quarter, This Year, Last Year, Custom

- (NSString *)retrieveChoice:(NSString *)choice {
	NSString *nextChoice = @"today"; // suitable default
	
	if ([choice isEqualToString:@"Today"]) {
		nextChoice = @"today";
	} else if ([choice isEqualToString:@"Yesterday"]) {
		nextChoice = @"yesterday";
	} else if ([choice isEqualToString:@"This Month"]) {
		nextChoice = @"this_month";
	} else if ([choice isEqualToString:@"Last Month"]) {
		nextChoice = @"last_month";
	} else if ([choice isEqualToString:@"This Quarter"]) {
		nextChoice = @"this_quarter";
	} else if ([choice isEqualToString:@"Last Quarter"]) {
		nextChoice = @"last_quarter";
	} else if ([choice isEqualToString:@"This Year"]) {
		nextChoice = @"this_year";
	} else if ([choice isEqualToString:@"Last Year"]) {
		nextChoice = @"last_year";
	} else if ([choice isEqualToString:@"Custom"]) {
		nextChoice = @"custom";
	}
	
	return nextChoice;
}

- (BOOL)isCustom {
	return [self.currentChoice isEqualToString:@"custom"];
}

- (void)handleCustom {
	BOOL isVisible = [self isCustom];
	
	self.loadCustomButton.hidden = !isVisible;
		
	[self.tableView reloadData];}

#pragma mark Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
	
	if (_selectingStartDate) {
		self.startDate = viewController.datePicker.date;
		_selectingStartDate = NO;
	} else {
		self.endDate = viewController.datePicker.date;
		_selectingEndDate = NO;
	}
	
	[self.tableView reloadData];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:_datePickerView];
}

@end