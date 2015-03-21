//
//  MapViewController.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/4/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

/*
 File: MapViewController.m
 Abstract: Secondary view controller used to display the map and found annotations.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "MapViewController.h"
#import "SearchResultsTableViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString* searchBarString;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MKLocalSearch* localSearch;
@property (nonatomic) CLLocationCoordinate2D previousLocation;
@property (nonatomic, strong) NSMutableArray* annotations;
@end

@implementation MapViewController

#pragma mark - Search and map methods

- (void)startSearch:(NSString *)searchString
{
    self.searchBarString = searchString;
    
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    

    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.previousLocation.latitude;
    newRegion.center.longitude = self.previousLocation.longitude;
    
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    
    [[DataSource sharedInstance] performMKLocalSearch:searchString withRegion:self.mapView.region];
    
}

- (void) searchResultTableViewControllerUpdated
{
    SearchResultsTableViewController* searchResultsTVC = [[SearchResultsTableViewController alloc] init];
    
    self.annotations = [NSMutableArray new];
    
    [searchResultsTVC initWithString:self.searchBarString andMapView:self.mapView];
}

- (void) mapItemsUpdated
{
    //Remove annotations
    for (int i = 0; i < [self.mapView.annotations count]; i++)
    {
            [self.mapView removeAnnotation:[self.mapView.annotations objectAtIndex:i]];
    }
    
    NSArray* mapItems = [DataSource sharedInstance].searchResponse.mapItems;
    self.annotations = [NSMutableArray new];
    
    
    
    for (MKMapItem* item in mapItems)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = item.placemark.coordinate;
        annotation.title      = item.name;
        annotation.subtitle   = item.placemark.title;
        [self.mapView addAnnotation:annotation];
        
        [self.annotations addObject:annotation];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
    //Check to see if Location Services is enabled, there are two state possibilities:
    //1) disabled for entire device, 2) disabled just for this app
    NSString *causeStr = nil;
    
    //Check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    //Check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"application";
    }
    else
    {
        //Otherwise, let's start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

#pragma mark - View methods

- (void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapItemsUpdated) name:@"Map Items" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultTableViewControllerUpdated) name:@"Map Items" object:nil];
    
}



- (void) viewWillLayoutSubviews
{
    self.searchBar.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, 50);
    
    self.mapView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void) viewDidLoad
{
    self.mapView = [[MKMapView alloc] init];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchBar.placeholder = @"Search for anything your heart desires";
    [self.view addSubview:self.searchBar];
    
    
    //Requesting always location
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - Location Manager Delegate Methods

- (void)mapView:(MKMapView *)theMapView didUpdateToUserLocation:(MKUserLocation *)location
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   [self zoomToUserLocation:self.mapView.userLocation];
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation || (self.previousLocation.latitude == userLocation.location.coordinate.latitude && self.previousLocation.longitude == userLocation.location.coordinate.longitude))
    {
        return;
    }
    
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(0.0125, 0.0125); //Zoom distance
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
    
    self.previousLocation = userLocation.location.coordinate;
    
}

#pragma mark - supportedInterfaceOrientations

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end