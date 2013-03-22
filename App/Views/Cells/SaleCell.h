//
//  SaleCell.h
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/17/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sale.h"

@interface SaleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) Sale *sale;

- (void)initializeSale:(Sale *)sale;

@end
