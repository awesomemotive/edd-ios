//
//  AppDelegate.m
//  EDDSalesTracker
//
//  Created by Matthew Strickland on 3/7/13.
//  Copyright (c) 2013 Easy Digital Downloads. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "NVSlideMenuController.h"
#import "UIColor+Helpers.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	
//	NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
//	[NSURLCache setSharedURLCache:URLCache];
	
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	[Crashlytics startWithAPIKey:@"907acff10b7b639198aadbeb5eca1950ffbfb149"];
	
	MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];	
	
    NVSlideMenuController *slideMenuController = [[NVSlideMenuController alloc] initWithMenuViewController:menuViewController andContentViewController:nav];
    slideMenuController.panGestureEnabled = NO;
	
	[self applyStyleSheet];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = slideMenuController;
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applyStyleSheet {
	UINavigationBar *navigationBar = [UINavigationBar appearance];
	[navigationBar setTintColor:[UIColor colorWithHexString:@"#1c5585"]];
}

@end
