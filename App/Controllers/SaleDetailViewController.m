//
//  SaleDetailViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/16/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "SaleDetailViewController.h"

#import "UIColor+Helpers.h"
#import "SaleProduct.h"
#import "SaleFee.h"
#import "NSString+DateHelper.h"
#import "SaleDetailCell.h"
#import "SettingsHelper.h"

@interface SaleDetailViewController () {
	Sale *_sale;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SaleDetailViewController

- (id)initWithSale:(Sale *)sale {
    self = [super init];
    if (self) {
		_sale = sale;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    self.navigationItem.leftBarButtonItem = nil;
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
	self.title = [NSString stringWithFormat:@"Sale #%i", _sale.saleID];

	[self.tableView registerNib:[self saleCellNib] forCellReuseIdentifier:@"SaleDetailCell"];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (UINib *)saleCellNib {
    return [UINib nibWithNibName:@"SaleDetailCell" bundle:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self hasFees] ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2 + [_sale.products count];
		case 1:
			return [self hasFees] ? [_sale.fees count] : 3;
		case 2:
			return [self hasFees] ? 3 : 0;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#009100"];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setCurrencyCode:[SettingsHelper getCurrency]];
    
    // Configure the cell...
	
	if (indexPath.section == 0) {
		int date = [_sale.products count];
		int buyer = [_sale.products count] + 1;
		
		// Details
		if (indexPath.row == date) {
			NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
			[timeFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
			NSString *timeString = [timeFormatter stringFromDate:_sale.date];
			
			cell.textLabel.text = @"Date:";
			cell.detailTextLabel.text = timeString;
			cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#000000"];
			
		} else if (indexPath.row == buyer) {
			cell.textLabel.text = @"Buyer:";
			cell.detailTextLabel.text = _sale.email;
			cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#000000"];
		} else {
			SaleProduct *product = [_sale.products objectAtIndex:indexPath.row];
			
			NSString *name = [NSString stringWithFormat:@"%@:", product.name];
			if (![NSString isNullOrWhiteSpace:product.priceName]) {
				name = [NSString stringWithFormat:@"%@ - %@:", product.name, product.priceName];
			}
			
			SaleDetailCell *saleDetailCell = [self.tableView dequeueReusableCellWithIdentifier:@"SaleDetailCell"];
			saleDetailCell.name.numberOfLines = 1;
			saleDetailCell.name.adjustsFontSizeToFitWidth = YES;
			saleDetailCell.name.text = name;
			saleDetailCell.price.text = [formatter stringFromNumber: [NSNumber numberWithFloat:product.price]];
			cell = saleDetailCell;
		}
		
	} else if (indexPath.section == 1 && [self hasFees]) {
		SaleFee *fee = [_sale.fees objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@:", fee.name];
		cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:fee.cost]];			
	} else {
		// Cost Breakdown
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Subtotal:";
			cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:_sale.subtotal]];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Taxes:";
			cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:_sale.tax]];
		} else {
			cell.textLabel.text = @"Total:";
			cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:_sale.total]];
		}
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Details";
		case 1:
			return [self hasFees] ? @"Fees" : @"Totals";
		case 2:
			return [self hasFees] ? @"Totals" : @"";
		default:
			return @"";
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)hasFees {
	return [_sale.fees count] > 0;
}

@end
