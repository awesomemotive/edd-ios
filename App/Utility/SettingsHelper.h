//
//  SettingsHelper.h
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/9/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_FOR_CURRENT_SITE_ID		@"EDDCurrentSiteID"
#define KEY_FOR_SITES				@"EDDSites"
#define KEY_FOR_SITE_ID				@"EDDSiteID"
#define KEY_FOR_SITE_NAME			@"EDDSiteName"
#define KEY_FOR_URL					@"EDDUrl"
#define KEY_FOR_API_KEY				@"EDDApiKey"
#define KEY_FOR_TOKEN				@"EDDToken"
#define KEY_FOR_CURRENCY			@"EDDCurrency"

@interface SettingsHelper : NSObject

+ (NSString *)newID;
+ (NSString *)getCurrentSiteID;
+ (void)setCurrentSiteID:(NSString *)siteID;
+ (NSDictionary *)getSites;
+ (void)saveSite:(NSDictionary *)site;
+ (void)removeSite:(NSDictionary *)site;
+ (NSDictionary *)getSiteForSiteID:(NSString *)siteID;
+ (NSString *)getSiteName;
+ (NSString *)getUrl;
+ (NSString *)getUrlForClient;
+ (NSString *)getApiKey;
+ (NSString *)getToken;
+ (NSString *)getCurrency;
+ (BOOL)requiresSetup;
+ (BOOL)requiresSetup:(NSDictionary *)site;

@end
