//
//  ProductDetailViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/16/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "UIColor+Helpers.h"
#import "SettingsHelper.h"

@interface ProductDetailViewController () {
	Product *_product;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ProductDetailViewController

- (id)initWithProduct:(Product *)product {
    self = [super init];
    if (self) {
		_product = product;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.leftBarButtonItem = nil;
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
	self.title = @"Product Details";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? 1 :2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
		cell.textLabel.numberOfLines = 1;
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = _product.title;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#009100"];

	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setCurrencyCode:[SettingsHelper getCurrency]];
    
    if (indexPath.section == 1) {
		// Totals
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Earnings";
			cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:_product.totalEarnings]];
		} else {
			cell.textLabel.text = @"Sales";
			cell.detailTextLabel.text = [NSString stringWithFormat: @"%i", _product.totalSales];
			cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#000000"];
		}
		
	} else {
		// Monthly
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Earnings";
			cell.detailTextLabel.text = [formatter stringFromNumber: [NSNumber numberWithFloat:_product.monthlyEarningsAverage]];
		} else {
			cell.textLabel.text = @"Sales";
			cell.detailTextLabel.text = [NSString stringWithFormat: @"%i", _product.monthlySalesAverage];
			cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#000000"];
		}
	}
	    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Product Name";
        case 1:
            return @"Totals";
        case 2:
            return @"Monthly Average";
        default:
            return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
