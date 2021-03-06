//
//  AppDelegate.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/4/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "SearchResultsTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*To add a map programmatically, create an instance of the MKMapView class, initialize it using the initWithFrame: method, and then add it as a subview to your window or view hierarchy. */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MapViewController* mapVC = [[MapViewController alloc] init];
    SearchResultsTableViewController* searchTableVC = [[SearchResultsTableViewController alloc] init];
    UITableViewController* savedResultsTableVC = [[UITableViewController alloc] init];

    
    UITabBarController* tabVC = [[UITabBarController alloc] init];
    
    [mapVC setTitle:@"Map"];
    [searchTableVC setTitle:@"Search Table"];
    [savedResultsTableVC setTitle:@"Saved POIs"];
    
    [tabVC setViewControllers:@[mapVC, searchTableVC, savedResultsTableVC] animated:YES];
    
    self.window.rootViewController = tabVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    NSLog(@"Did finish launching");

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

@end
