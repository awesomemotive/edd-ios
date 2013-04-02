//
//  ProductCell.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/17/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "ProductCell.h"

#import "SettingsHelper.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initializeProduct:(Product *)product {
	self.product = product;
	
	[self setupUserInterface];
}

- (void)setupUserInterface {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setCurrencyCode:[SettingsHelper getCurrency]];
	
	self.title.text = self.product.title;
	self.earnings.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber: [NSNumber numberWithFloat:self.product.totalEarnings]]];
	self.sales.text = [NSString stringWithFormat:@"%i %@", self.product.totalSales, self.product.totalSales == 1 ? @"Sale" : @"Sales"];
}

@end
