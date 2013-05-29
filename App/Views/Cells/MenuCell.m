//
//  MenuCell.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "MenuCell.h"

#import "BButton.h"
#import "SettingsHelper.h"
#import "UIColor+Helpers.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSiteID:(NSString *)siteID {
	_siteID = siteID;
	
	self.labelCheckmark.font = [UIFont fontWithName:@"FontAwesome" size:14.0f];
	
	if ([[SettingsHelper getCurrentSiteID] isEqualToString:siteID]) {
		self.labelCheckmark.text = [NSString stringFromAwesomeIcon:FAIconCheck];
		self.labelCheckmark.hidden = NO;
	} else {
		self.labelCheckmark.text = @"";
		self.labelCheckmark.hidden = YES;
	}	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	
	if (highlighted) {
		self.label.shadowColor = [UIColor clearColor];
	} else {
		self.label.shadowColor = [UIColor blackColor];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	
	if (selected) {
		self.label.shadowColor = [UIColor clearColor];
	} else {
		self.label.shadowColor = [UIColor blackColor];
	}
}

@end
