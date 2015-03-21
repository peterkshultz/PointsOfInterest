//
//  SavedPOIsTableViewController.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 3/6/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import "SavedPOIsTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "DataSource.h"
#import "TableViewCell.h"

@interface SavedPOIsTableViewController ()

@property (nonatomic, strong) NSString *kCellIdentifier;

@end

@implementation SavedPOIsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentifier"];
}

- (void) viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}


- (void) viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savedPOIs) name:@"savedPOIsUpdated" object:nil];
    [self.tableView reloadData];

}

- (void) savedPOIsUpdated{
    [self.tableView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.kCellIdentifier = @"cellIdentifier";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
    
    MKMapItem *mapItem = [[DataSource sharedInstance].savedPOIs objectAtIndex:indexPath.row];
    label.text = mapItem.placemark.title;
    titleLabel.text = mapItem.name;
    
    UIButton* starButton = (UIButton*)[cell viewWithTag:4];
    
    [starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [SearchResultsTableViewController fillStarIfNecessary:starButton MapItem:mapItem];

    return cell;
}

-(void) starButtonClicked:(id) sender{
    
    [SearchResultsTableViewController starClicked:sender tableView:self.tableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [DataSource sharedInstance].savedPOIs.count;
}

@end
