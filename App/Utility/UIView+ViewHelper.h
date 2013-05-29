//
//  UIView+ViewHelper.h
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewHelper)

- (UIView *) findFirstResponder;
- (void) disableScrollsToTopPropertyOnMeAndAllSubviews;

@end
