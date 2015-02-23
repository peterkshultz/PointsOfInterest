//
//  SearchResultsTableViewController.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/20/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "MapViewController.h"
#import "DataSource.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) NSArray* mapItems;
@property (nonatomic, strong) NSString *kCellIdentifier;


@end

@implementation SearchResultsTableViewController

#pragma mark - UITableView delegate methods

- (void) initWithString:(NSString*) searchString andMapView:(MKMapView*) mapView
{
    self.searchString = searchString;
    self.mapView = mapView;
    self.mapItems = [DataSource sharedInstance].searchResponse.mapItems;

    for (MKMapItem* item in self.mapItems)
    {
        
        NSLog(@"%@", item.name);

    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void) viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
        
}

- (void) viewDidLoad
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Returning zero for whatever reason
    return self.mapItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.kCellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    
//    MKMapItem *mapItem = [self.response.mapItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = mapItem.name;
    
    
    for (MKMapItem* item in self.mapItems){
        
        cell.textLabel.text = item.name;
        NSLog(@"In cellForRow");
    }

    
    cell.textLabel.text=[self.mapItems objectAtIndex:indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // pass the new bounding region to the map destination view controller
//    self.mapViewController.boundingRegion = self.region;
    
    // pass the individual place to our map destination view controller
    NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];
//    self.mapViewController.mapItemList = [NSArray arrayWithObject:[self.response.mapItems objectAtIndex:selectedItem.row]];
    
//    [self.detailSegue perform];
}

@end
