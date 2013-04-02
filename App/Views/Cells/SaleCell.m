//
//  SaleCell.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/17/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "SaleCell.h"

#import "SettingsHelper.h"

@implementation SaleCell

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

- (void)initializeSale:(Sale *)sale {
	self.sale = sale;
	
	[self setupUserInterface];
}

- (void)setupUserInterface {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setCurrencyCode:[SettingsHelper getCurrency]];
	
	self.total.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber: [NSNumber numberWithFloat:self.sale.total]]];
	self.email.text = self.sale.email;
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateFormat:@"MMM dd"];
	self.dateLabel.text = [timeFormatter stringFromDate:self.sale.date];
}
@end
