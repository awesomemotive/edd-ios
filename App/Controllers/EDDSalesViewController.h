//
//  EDDSalesViewController.h
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/8/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "EDDBaseTableViewController.h"

@interface EDDSalesViewController : EDDBaseTableViewController<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _currentPage;
    NSInteger _totalPages;
}

@property (nonatomic, strong) UIBarButtonItem *refresh;

@end