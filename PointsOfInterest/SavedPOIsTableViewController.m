//
//  SavedPOIsTableViewController.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 3/6/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import "SavedPOIsTableViewController.h"
#import "SearchResultsTableViewController.h"
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
    
    
    return cell;
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
    NSLog(@"%i", [DataSource sharedInstance].savedPOIs.count);
    return [DataSource sharedInstance].savedPOIs.count;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
