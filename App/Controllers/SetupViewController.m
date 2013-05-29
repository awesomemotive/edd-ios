//
//  SettingsViewController.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "SetupViewController.h"

#import "BSModalPickerView.h"
#import "EDDAPIClient.h"
#import "NSString+DateHelper.h"
#import "SettingsHelper.h"
#import "UIColor+Helpers.h"
#import "UIView+ViewHelper.h"

@interface SetupViewController () {
	BOOL initialSetup;
	BOOL siteCreation;
}


@property (nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) UITextField *siteName;
@property (nonatomic) UITextField *url;
@property (nonatomic) UITextField *apiKey;
@property (nonatomic) UITextField *token;
@property (nonatomic) NSString *currency;

@property (nonatomic) NSDictionary *siteForEditing;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SetupViewController

- (id)initForInitialSetup {
	self = [super init];
	if (!self) return nil;
	
	initialSetup = YES;
	
	return self;
}

- (id)initForSiteCreation:(NSDictionary *)site {
	self = [super init];
	if (!self) return nil;
	
	siteCreation = YES;
	self.siteForEditing = site;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = NSLocalizedString(@"Setup", nil);
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	if (initialSetup) {
		self.navigationItem.leftBarButtonItem = nil;
		self.title = @"Getting Started";
	}
	
	if (siteCreation) {
		self.navigationItem.leftBarButtonItem = nil;
	}
	
	[self setupTextFields];
	
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#ededed"]];
	self.tableView.autoresizesSubviews = YES;
	
    [self.view disableScrollsToTopPropertyOnMeAndAllSubviews];
    self.tableView.scrollsToTop = YES;
	
	[self.tableView reloadData];
}

- (void)setupTextFields {
	self.siteName = [[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 21)];
	[self.siteName setPlaceholder:@"My EDD Site"];
	self.siteName.font = [UIFont fontWithName:@"System" size:12.0f];
	[self.siteName setKeyboardType:UIKeyboardTypeAlphabet];
	[self.siteName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[self.siteName setReturnKeyType:UIReturnKeyNext];
	[self.siteName setTag:1];
	self.siteName.autocorrectionType = UITextAutocorrectionTypeNo;
	self.siteName.adjustsFontSizeToFitWidth = YES;
	self.siteName.delegate = self;
	
	self.url = [[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 21)];
	[self.url setPlaceholder:@"http://yoursite.com/"];
	self.url.font = [UIFont fontWithName:@"System" size:12.0f];
	[self.url setKeyboardType:UIKeyboardTypeURL];
	[self.url setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[self.url setReturnKeyType:UIReturnKeyNext];
	[self.url setTag:2];
	self.url.autocorrectionType = UITextAutocorrectionTypeNo;
	self.url.adjustsFontSizeToFitWidth = YES;
	self.url.delegate = self;
	
	self.apiKey = [[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 21)];
	[self.apiKey setPlaceholder:@"My API Key"];
	self.apiKey.font = [UIFont fontWithName:@"System" size:12.0f];
	[self.apiKey setKeyboardType:UIKeyboardTypeAlphabet];
	[self.apiKey setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[self.apiKey setReturnKeyType:UIReturnKeyNext];
	[self.apiKey setTag:3];
	self.apiKey.autocorrectionType = UITextAutocorrectionTypeNo;
	self.apiKey.adjustsFontSizeToFitWidth = YES;
	self.apiKey.delegate = self;
	
	self.token = [[UITextField alloc] initWithFrame:CGRectMake(120, 11, 180, 21)];
	[self.token setPlaceholder:@"My Token"];
	self.token.font = [UIFont fontWithName:@"System" size:12.0f];
	[self.token setKeyboardType:UIKeyboardTypeEmailAddress];
	[self.token setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[self.token setReturnKeyType:UIReturnKeyGo];
	[self.token setTag:4];
	self.token.autocorrectionType = UITextAutocorrectionTypeNo;
	self.token.adjustsFontSizeToFitWidth = YES;
	self.token.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self loadSettings];
}

- (void)loadSettings {
	if (siteCreation) {
		NSString *siteName = [self.siteForEditing objectForKey:KEY_FOR_SITE_NAME];
		if ([NSString isNullOrWhiteSpace:siteName]) {
			siteName = @"";
		}
		self.siteName.text = siteName;
		
		NSString *url = [self.siteForEditing objectForKey:KEY_FOR_URL];
		if ([NSString isNullOrWhiteSpace:url]) {
			url = @"";
		}
		self.url.text = url;
		
		NSString *apiKey = [self.siteForEditing objectForKey:KEY_FOR_API_KEY];
		if ([NSString isNullOrWhiteSpace:apiKey]) {
			apiKey = @"";
		}
		self.apiKey.text = apiKey;
				
		NSString *token = [self.siteForEditing objectForKey:KEY_FOR_TOKEN];
		if ([NSString isNullOrWhiteSpace:token]) {
			token = @"";
		}
		self.token.text = token;
				
		NSString *currency = [self.siteForEditing objectForKey:KEY_FOR_CURRENCY];
		if ([NSString isNullOrWhiteSpace:currency]) {
			NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
			[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			currency = currencyFormatter.currencyCode;
		}
		self.currency = currency;
	} else {
		self.siteName.text = [SettingsHelper getSiteName];
		self.url.text = [SettingsHelper getUrl];
		self.apiKey.text = [SettingsHelper getApiKey];
		self.token.text = [SettingsHelper getToken];
		self.currency = [SettingsHelper getCurrency];
	}
}

- (void)save {	
	NSURL *candidateURL = [NSURL URLWithString:self.url.text];
	if (candidateURL && candidateURL.scheme && candidateURL.host) {
		// URL is good but does it end with a slash?
		NSString *last = [self.url.text substringFromIndex:[self.url.text length] - 1];
		if (![last isEqualToString:@"/"]) {
			self.url.text = [NSString stringWithFormat:@"%@/", self.url.text];
		}
		
	} else {
		[self showError:@"URL is invalid, please fix before continuing."];
		return;
	}
	
	NSMutableDictionary *site;
	
	if (!siteCreation) {
		site = [[SettingsHelper getSiteForSiteID:[SettingsHelper getCurrentSiteID]] mutableCopy];
	} else {
		if (self.siteForEditing) {
			site = [self.siteForEditing mutableCopy];
		}
	}
	
	if (site == nil) {
		site = [NSMutableDictionary dictionary];
		
		NSString *siteID = [SettingsHelper newID];
		[site setObject:siteID forKey:KEY_FOR_SITE_ID];
	}
	
	[site setObject:self.siteName.text forKey:KEY_FOR_SITE_NAME];
	[site setObject:self.url.text forKey:KEY_FOR_URL];
	[site setObject:[self.apiKey.text trimmed] forKey:KEY_FOR_API_KEY];
	[site setObject:[self.token.text trimmed] forKey:KEY_FOR_TOKEN];
	[site setObject:[self.currency  trimmed] forKey:KEY_FOR_CURRENCY];
	
	if ([SettingsHelper requiresSetup:site]) {
		[self showError:@"Please fill out all fields before continuing."];
		return;
	}
	
	[SettingsHelper saveSite:site];
	
    [[EDDAPIClient sharedClient] reload];
	
	if (initialSetup) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SettingsInitialSetup" object:self];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your settings were successfully saved." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

- (void)showError:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
}

#pragma mark - IBActions

- (IBAction)saveSettings:(id)sender {
	[self save];
}

#pragma mark Keyboard handling selectors

- (void)keyboardWasShown:(NSNotification *)notification {
    keyboardShown = YES;
    keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    tapRecognizer.delegate = self;
    self.editingField = [self.view findFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.editingField = nil;
    keyboardShown = NO;
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    if (tapRecognizer != nil) {
        [self.editingField endEditing: NO];
		
        [self.view removeGestureRecognizer:tapRecognizer];
        tapRecognizer = nil;
    }
}

#pragma mark UITextFieldDelegate selectors

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(self.editingField == textField)
        self.editingField = nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == self.token) {
		[textField setReturnKeyType:UIReturnKeyDone];
	}
	
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField returnKeyType] != UIReturnKeyDone) {
        NSInteger nextTag = [textField tag] + 1;

		UIView *nextTextField = nil;
		switch (nextTag) {
			case 2:
				nextTextField = self.url;
				break;
			case 3:
				nextTextField = self.apiKey;
				break;
			case 4:
				nextTextField = self.token;
				break;
		}
		
        [nextTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
		
		if (textField == self.token) {
			[self save];
		}
    }
	
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	
	UITextField *textField = nil;
	
	switch (indexPath.row) {
		case 0:
			textField = self.siteName;
			cell.textLabel.text = @"Site Name:";
			break;
		case 1:
			textField = self.url;
			cell.textLabel.text = @"Site URL:";
			break;
		case 2:
			textField = self.apiKey;
			cell.textLabel.text = @"API Key:";
			break;
		case 3:
			textField = self.token;
			cell.textLabel.text = @"Token:";
			break;
		default:
			cell.textLabel.text = @"Currency:";
			cell.detailTextLabel.text = self.currency;
			break;
	}
	
	[cell addSubview:textField];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITextField *textField = nil;
	switch (indexPath.row) {
		case 0:
			textField = self.siteName;
			break;
		case 1:
			textField = self.url;
			break;
		case 2:
			textField = self.apiKey;
			break;
		case 3:
			textField = self.token;
			break;
		case 4:
			[self handleCurrencySelection];
			[tableView deselectRowAtIndexPath: indexPath animated: NO];
			return;
	}
	
	if (textField && ![textField isFirstResponder]) {
		[textField becomeFirstResponder];
	}
	
	[tableView deselectRowAtIndexPath: indexPath animated: NO];
}

- (void)handleCurrencySelection {
	NSArray *choices = [NSArray arrayWithObjects: @"USD",	@"AFN",	@"ALL",	@"ANG",	@"ARS",	@"AUD",	@"AWG",	@"AZN",	@"BAM",	@"BBD",	@"BGN",	@"BMD",	@"BND",	@"BOB",	@"BRL",	@"BSD",	@"BWP",	@"BYR",	@"BZD",	@"CAD",	@"CHF",	@"CLP",	@"CNY",	@"COP",	@"CRC",	@"CUP",	@"CZK",	@"DKK",	@"DOP",	@"EEK",	@"EGP",	@"EUR",	@"FJD",	@"FKP",	@"GBP",	@"GGP",	@"GHC",	@"GIP",	@"GTQ",	@"GYD",	@"HKD",	@"HNL",	@"HRK",	@"HUF",	@"IDR",	@"ILS",	@"IMP",	@"INR",	@"IRR",	@"ISK",	@"JEP",	@"JMD",	@"JPY",	@"KGS",	@"KHR",	@"KPW",	@"KRW",	@"KYD",	@"KZT",	@"LAK",	@"LBP",	@"LKR",	@"LRD",	@"LTL",	@"LVL",	@"MKD",	@"MNT",	@"MUR",	@"MXN",	@"MYR",	@"MZN",	@"NAD",	@"NGN",	@"NIO",	@"NOK",	@"NPR",	@"NZD",	@"OMR",	@"PAB",	@"PEN",	@"PHP",	@"PKR",	@"PLN",	@"PYG",	@"QAR",	@"RON",	@"RSD",	@"RUB",	@"SAR",	@"SBD",	@"SCR",	@"SEK",	@"SGD",	@"SHP",	@"SOS",	@"SRD",	@"SVC",	@"SYP",	@"THB",	@"TRL",	@"TRY",	@"TTD",	@"TVD",	@"TWD",	@"UAH",	@"UYU",	@"UZS",	@"VEF",	@"VND",	@"XCD",	@"YER",	@"ZAR",	@"ZWD", nil];
	
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:choices];
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
        NSLog(@"Selected value: %@", pickerView.selectedValue);
		self.currency = pickerView.selectedValue;
		[self.tableView reloadData];
    }];
}

@end
