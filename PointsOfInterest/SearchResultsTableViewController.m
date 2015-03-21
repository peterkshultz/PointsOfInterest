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
#import "DetailViewController.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *kCellIdentifier;


@end

@implementation SearchResultsTableViewController

#pragma mark - UITableView delegate methods

- (void) initWithString:(NSString*) searchString andMapView:(MKMapView*) mapView
{
    self.searchString = searchString;
    self.mapView = mapView;
    self.searchBar.text = searchString;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void) viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.tableView setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

- (void) viewDidLoad
{
    self.tableView.delegate = self;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:self.searchBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentifier"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataSource sharedInstance].searchResponse.mapItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.kCellIdentifier = @"cellIdentifier";
        
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
    
    MKMapItem *mapItem = [[DataSource sharedInstance].searchResponse.mapItems objectAtIndex:indexPath.row];
    label.text = mapItem.placemark.title;
    titleLabel.text = mapItem.name;
    
    UIButton* starButton = (UIButton*)[cell viewWithTag:4];
    [starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [SearchResultsTableViewController fillStarIfNecessary:starButton MapItem:mapItem];
        
    return cell;
}

+ (void) fillStarIfNecessary: (UIButton*) star MapItem:(MKMapItem*) mapItem{
    
    if ([[DataSource sharedInstance].savedPOIs containsObject:mapItem])
    {
        [SearchResultsTableViewController fillStar:true Button:star];
    }
    
    else
    {
        [SearchResultsTableViewController fillStar:false Button:star];
    }
    
}

- (void) starButtonClicked:(id) sender{
    
    [SearchResultsTableViewController starClicked:sender tableView: self.tableView];
    
}

+(void) starClicked: (id) sender tableView: (UITableView*) tableView{
    
    UIButton* starButton = (UIButton*) sender;
    UITableViewCell* cell = (UITableViewCell*) starButton.superview.superview;
    
    NSIndexPath* indexPath = [tableView indexPathForCell:cell];
    
    MKMapItem *selectedMapItem = [[DataSource sharedInstance].searchResponse.mapItems objectAtIndex:indexPath.row];
    
    NSData* unfilledData = UIImagePNGRepresentation([UIImage imageNamed:@"unfilledStarEdited.png"]);
    NSData* filledData = UIImagePNGRepresentation([UIImage imageNamed:@"filledStarEdited.png"]);
    NSData* currentBackgroundData = UIImagePNGRepresentation(starButton.currentBackgroundImage);
    
    if ([unfilledData isEqual:currentBackgroundData])
    {
        //SAVE TO DISK
        [[DataSource sharedInstance].savedPOIs addObject:selectedMapItem];
        
        [SearchResultsTableViewController fillStar:true Button:starButton];
    }
    
    else if ([filledData isEqual:currentBackgroundData])
    {
        
        //UNSAVE TO DISK
        [[DataSource sharedInstance].savedPOIs removeObject:selectedMapItem];
        [SearchResultsTableViewController fillStar:false Button:starButton];
    }
    
    
    [[DataSource sharedInstance] saveToDisk];
    
}

+(void) fillStar:(bool) filled Button: (UIButton*) starButton{
    
    if (filled)
    {
        UIImage* filledStar = [UIImage imageNamed:@"filledStarEdited.png"];
        
        [starButton setBackgroundImage:filledStar forState:UIControlStateNormal];
    }
    
    else
    {
        UIImage* unfilledStar = [UIImage imageNamed:@"unfilledStarEdited.png"];
        
        [starButton setBackgroundImage:unfilledStar forState:UIControlStateNormal];
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];
    
    DetailViewController* detailViewController = [[DetailViewController alloc] init];
    
    
    [self presentViewController:detailViewController animated:true completion:^{
        
    }];

    //More work to be done here
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
