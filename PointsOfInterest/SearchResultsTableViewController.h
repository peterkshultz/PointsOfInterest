//
//  SearchResultsTableViewController.h
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/20/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchResultsTableViewController : UITableViewController

- (void) initWithString:(NSString*) searchString andMapView:(MKMapView*) mapView;

@end
