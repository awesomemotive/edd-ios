//
//  SettingsViewController.h
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "BaseViewController.h"

@interface SetupViewController : BaseViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL keyboardShown;
    CGPoint point;
    CGRect keyboardRect;
    UITextField *activeTextField;
    UITapGestureRecognizer *tapRecognizer;
}

@property (nonatomic, strong) id editingField;

- (IBAction)saveSettings:(id)sender;

- (id)initForInitialSetup;
- (id)initForSiteCreation:(NSDictionary *)site;

@end
