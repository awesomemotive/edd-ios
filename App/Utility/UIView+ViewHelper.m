//
//  UIView+ViewHelper.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "UIView+ViewHelper.h"

@implementation UIView (ViewHelper)

- (UIView *) findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (void) disableScrollsToTopPropertyOnMeAndAllSubviews {
    if ([self isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)self).scrollsToTop = NO;
    }
	
    for (UIView *subview in self.subviews) {
        [subview disableScrollsToTopPropertyOnMeAndAllSubviews];
    }
}

@end
