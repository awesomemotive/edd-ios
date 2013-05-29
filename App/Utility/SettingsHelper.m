//
//  SettingsHelper.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "SettingsHelper.h"

#import "NSString+DateHelper.h"

@implementation SettingsHelper

+ (NSString *)newID {	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateFormat:@"MMddyyyyhhmmss"];
	return [timeFormatter stringFromDate:[NSDate date]];	
}

+ (NSString *)getCurrentSiteID {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_FOR_CURRENT_SITE_ID] == nil) {
		return @"";
	}
	return [[NSUserDefaults standardUserDefaults] stringForKey:KEY_FOR_CURRENT_SITE_ID];
}

+ (void)setCurrentSiteID:(NSString *)siteID {
	[[NSUserDefaults standardUserDefaults] setObject:siteID forKey:KEY_FOR_CURRENT_SITE_ID];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getSites {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_FOR_SITES] == nil) {
		return [NSDictionary dictionary];
	}
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:KEY_FOR_SITES];
}

+ (void)saveSite:(NSDictionary *)site {
	NSMutableDictionary *currentSites = [[self getSites] mutableCopy];
	NSMutableDictionary *currentSite = [[currentSites objectForKey:[site objectForKey:KEY_FOR_SITE_ID]] mutableCopy];
	
	if (currentSite != nil) {
		[currentSite setObject:[site objectForKey:KEY_FOR_SITE_NAME] forKey:KEY_FOR_SITE_NAME];
		[currentSite setObject:[site objectForKey:KEY_FOR_URL] forKey:KEY_FOR_URL];
		[currentSite setObject:[site objectForKey:KEY_FOR_API_KEY] forKey:KEY_FOR_API_KEY];
		[currentSite setObject:[site objectForKey:KEY_FOR_TOKEN] forKey:KEY_FOR_TOKEN];
		[currentSite setObject:[site objectForKey:KEY_FOR_CURRENCY] forKey:KEY_FOR_CURRENCY];
	} else {
		[currentSites setObject:site forKey:[site objectForKey:KEY_FOR_SITE_ID]];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:currentSites forKey:KEY_FOR_SITES];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSString *siteID = [site objectForKey:KEY_FOR_SITE_ID];
	[self setCurrentSiteID:siteID];
}

+ (void)removeSite:(NSDictionary *)site {
	NSMutableDictionary *currentSites = [[self getSites] mutableCopy];
	NSMutableDictionary *currentSite = [currentSites objectForKey:[site objectForKey:KEY_FOR_SITE_ID]];
	
	[currentSites removeObjectForKey:[currentSite objectForKey:KEY_FOR_SITE_ID]];
	[[NSUserDefaults standardUserDefaults] setObject:currentSites forKey:KEY_FOR_SITES];
	[[NSUserDefaults standardUserDefaults] synchronize];
} 

+ (NSDictionary *)getSiteForSiteID:(NSString *)siteID {
	NSDictionary *currentSites = [self getSites];
	return [currentSites objectForKey:siteID];
}

+ (NSString *)getSiteName {
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	if (site == nil) return @"";
	return [site objectForKey:KEY_FOR_SITE_NAME];
}

+ (NSString *)getUrl {
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	if (site == nil) return @"";
	return [site objectForKey:KEY_FOR_URL];
}

+ (NSString *)getUrlForClient {
    return [NSString stringWithFormat:@"%@edd-api/", [self getUrl]];
}

+ (NSString *)getApiKey{
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	if (site == nil) return @"";
	return [site objectForKey:KEY_FOR_API_KEY];
}

+ (NSString *)getToken{
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	if (site == nil) return @"";
	return [site objectForKey:KEY_FOR_TOKEN];
}

+ (NSString *)getCurrency{
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	if (site == nil || [site objectForKey:KEY_FOR_CURRENCY] == nil) {
		NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		return currencyFormatter.currencyCode;
	}
	return [site objectForKey:KEY_FOR_CURRENCY];
}

+ (BOOL)requiresSetup {
	NSDictionary *site = [self getSiteForSiteID:[self getCurrentSiteID]];
	return [self requiresSetup:site];
}

+ (BOOL)requiresSetup:(NSDictionary *)site {
	if (site == nil) return YES;
	if ([NSString isNullOrWhiteSpace:[site objectForKey:KEY_FOR_SITE_NAME]]) return YES;
	if ([NSString isNullOrWhiteSpace:[site objectForKey:KEY_FOR_URL]]) return YES;
	if ([NSString isNullOrWhiteSpace:[site objectForKey:KEY_FOR_API_KEY]]) return YES;
	if ([NSString isNullOrWhiteSpace:[site objectForKey:KEY_FOR_TOKEN]]) return YES;
	if ([NSString isNullOrWhiteSpace:[site objectForKey:KEY_FOR_CURRENCY]]) return YES;
	
	return NO;
}

@end
