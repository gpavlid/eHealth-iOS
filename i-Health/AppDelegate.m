//
//  AppDelegate.m
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL) initializeDefaults {

	// initialize all variables according to the setting bundle
	if (iHealthDebug) NSLog(@"Getting defaults from the Settings.bundle...");
	NSUserDefaults * defaultSettings = [NSUserDefaults standardUserDefaults];
	[defaultSettings synchronize];
	// define the bundle name to use
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
	// check if the bundle is not found
	if(!settingsBundle) {
		if (iHealthDebug) NSLog(@"Settings.bundle not found in this project!");
		return NO;
	}
	// get all settings from the root element
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
	NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
	NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
	// for all entries in preferences
	for (NSDictionary *prefSpecification in preferences) {
		NSString *key = [prefSpecification objectForKey:@"Key"];
		if (key) {
			id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
			[defaultsToRegister setObject:objectToSet forKey:key];
			if (iHealthDebug) NSLog(@"Key %@ was set to object %@", key, objectToSet);
		}
	}
	[defaultSettings registerDefaults:defaultsToRegister];
	[defaultSettings synchronize];
	return YES;
	
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.

	bool retVal = [self initializeDefaults];
	return retVal;
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

@end
