//
//  Data.h
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/20/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataSource : NSObject

+(instancetype) sharedInstance;

- (void) performMKLocalSearch: (NSString*) searchString withRegion: (MKCoordinateRegion) region;

- (void) saveToDisk;


@property (nonatomic, strong) MKLocalSearchResponse* searchResponse;
@property (nonatomic, strong) NSMutableArray* savedPOIs;

@end
