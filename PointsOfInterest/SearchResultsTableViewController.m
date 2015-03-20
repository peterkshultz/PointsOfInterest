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
#import "TableViewCell.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString* searchString;
//@property (nonatomic, strong) NSArray* mapItems;
@property (nonatomic, strong) NSString *kCellIdentifier;


@end

@implementation SearchResultsTableViewController

#pragma mark - UITableView delegate methods

- (void) initWithString:(NSString*) searchString andMapView:(MKMapView*) mapView
{
    self.searchString = searchString;
    self.mapView = mapView;
//    self.tableView.delegaste = self;
//    self.mapItems = [DataSource sharedInstance].searchResponse.mapItems;

//    for (MKMapItem* item in self.mapItems)
//    {
//        
//        NSLog(@"%@", item.name);
//
//    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void) viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.tableView setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
}

- (void) viewDidLoad
{
    self.tableView.delegate = self;
//    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentifier"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%i", [DataSource sharedInstance].searchResponse.mapItems.count);
    return [DataSource sharedInstance].searchResponse.mapItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In cellForRow");
    
    self.kCellIdentifier = @"cellIdentifier";
        
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
    
    MKMapItem *mapItem = [[DataSource sharedInstance].searchResponse.mapItems objectAtIndex:indexPath.row];
    label.text = mapItem.placemark.title;
    titleLabel.text = mapItem.name;
    
    UIButton* starButton = (UIButton*)[cell viewWithTag:4];
    [starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    //More work to be done here--we want more than just the item name to be displayed.
    
    return cell;
}

- (void) starButtonClicked:(id) sender{
    
    UIButton* starButton = (UIButton*) sender;
    UITableViewCell* cell = (UITableViewCell*) starButton.superview.superview;
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    MKMapItem *selectedMapItem = [[DataSource sharedInstance].searchResponse.mapItems objectAtIndex:indexPath.row];
    
    NSData* unfilledData = UIImagePNGRepresentation([UIImage imageNamed:@"unfilledStarEdited.png"]);
    NSData* filledData = UIImagePNGRepresentation([UIImage imageNamed:@"filledStarEdited.png"]);
    NSData* currentBackgroundData = UIImagePNGRepresentation(starButton.currentBackgroundImage);
    
    if ([unfilledData isEqual:currentBackgroundData])
    {
        UIImage* filledStar = [UIImage imageNamed:@"filledStarEdited.png"];
        
        [starButton setBackgroundImage:filledStar forState:UIControlStateNormal];
        
        //SAVE TO DISK
        [[DataSource sharedInstance].savedPOIs addObject:selectedMapItem];
    }
    
    else if ([filledData isEqual:currentBackgroundData])
    {
        UIImage* unfilledStar = [UIImage imageNamed:@"unfilledStarEdited.png"];
        
        [starButton setBackgroundImage:unfilledStar forState:UIControlStateNormal];
        
        
        //UNSAVE TO DISK
        [[DataSource sharedInstance].savedPOIs removeObject:selectedMapItem];
    }
    
    
    [[DataSource sharedInstance] saveToDisk];
    
    NSLog(@"hello");
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];

    //More work to be done here
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
