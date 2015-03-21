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
#import "SavedPOIsTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    //Declare and initialize necessary view controllers (and tab controller)
    MapViewController* mapVC = [[MapViewController alloc] init];
    SearchResultsTableViewController* searchTableVC = [[SearchResultsTableViewController alloc] init];
    SavedPOIsTableViewController* savedResultsTableVC = [[SavedPOIsTableViewController alloc] init];
    UITabBarController* tabVC = [[UITabBarController alloc] init];
    
    //Set titles of each tab
    [mapVC setTitle:@"Map View"];
    [searchTableVC setTitle:@"Search View"];
    [savedResultsTableVC setTitle:@"Saved Items"];
    
    //Add them to tabVC
    [tabVC setViewControllers:@[mapVC, searchTableVC, savedResultsTableVC] animated:YES];
    
    
    //Declare and initialize tab bar items
    UITabBarItem* mapVCTabBar = [tabVC.tabBar.items objectAtIndex:0];
    UITabBarItem* searchTableVCTabBar = [tabVC.tabBar.items objectAtIndex:1];
    UITabBarItem* savedResultsTableVCTabItem = [tabVC.tabBar.items objectAtIndex:2];
    
    
    //Set images of tab bar items
    [mapVCTabBar setImage:[UIImage imageNamed:@"pinIcon.png"]];
    [searchTableVCTabBar setImage:[UIImage imageNamed:@"listView.png"]];
    [savedResultsTableVCTabItem setImage:[UIImage imageNamed:@"unfilledStarEdited.png"]];

    
    
    //Obligatory root code
    self.window.rootViewController = tabVC;
    self.window.backgroundColor = [UIColor whiteColor];
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

@end
