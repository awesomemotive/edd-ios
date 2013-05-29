//
//  ProductsViewController.m
//  EDDproductsTracker
//
//  Created by Matthew Strickland on 3/8/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "ProductsViewController.h"

#import "NSString+DateHelper.h"
#import "Product.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "SVProgressHUD.h"
#import "UIColor+Helpers.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+ViewHelper.h"

const int kProductsLoadingCellTag = 1273;

@interface ProductsViewController ()

- (void)refresh:(id)sender;
- (void)reload:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *products;

@end

@implementation ProductsViewController

@synthesize products = _products;

- (void)refresh:(id)sender {
	_currentPage = 0;
	_totalPages = 99;
	
	self.products = [NSMutableArray array];
	
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
	
	[self.tableView reloadData];
}

- (void)reload:(id)sender {
	if (_currentPage == 0) return;
	
	[SVProgressHUD showWithStatus:@"Loading Products..." maskType:SVProgressHUDMaskTypeClear];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Product globalProductsWithPage:_currentPage andWithBlock:^(NSArray *products, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
			if ([products count] != PAGING_RETURN) {
				_totalPages = _currentPage;
			}
			
			for (Product *product in products) {
				if (![self.products containsObject:product]) {
					[self.products addObject:product];
				}
			}
            [self.tableView reloadData];
        }
        
		[SVProgressHUD dismiss];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.products = [NSMutableArray array];
	
    _currentPage = 0;
	_totalPages = 99;
    
    self.title = NSLocalizedString(@"Products", nil);
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	
    [self.tableView registerNib:[self productCellNib] forCellReuseIdentifier:@"ProductCell"];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
    [self.view disableScrollsToTopPropertyOnMeAndAllSubviews];
    self.tableView.scrollsToTop = YES;
    
    [self reload:nil];
}

- (UINib *)productCellNib {
    return [UINib nibWithNibName:@"ProductCell" bundle:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentPage == 0) {
        return 1;
	}
    
    if (_currentPage < _totalPages) {
        return [self.products count] + 1;
    }
	
	return [self.products count];
}

- (UITableViewCell *)saleCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProductCell";
    ProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (!cell) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle
								  reuseIdentifier:cellIdentifier];
    }
    
	Product *product = [self.products objectAtIndex:indexPath.row];
	[cell initializeProduct:product];
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
												   reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kProductsLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.products.count) {
        return [self saleCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kProductsLoadingCellTag) {
        _currentPage++;
        [self reload:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Product *product = [self.products objectAtIndex:indexPath.row];
	ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithProduct:product];
	
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
