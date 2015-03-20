//
//  Data.m
//  PointsOfInterest
//
//  Created by Peter Shultz on 2/20/15.
//  Copyright (c) 2015 Peter Shultz. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void) performMKLocalSearch: (NSString*) searchString withRegion: (MKCoordinateRegion) region{
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = region;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            NSLog(@"Map Items: %@", response.mapItems);
            self.searchResponse = response;
            
            NSArray* mapItems = response.mapItems;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Map Items" object:nil];
        }

    };
    
    
    MKLocalSearch* localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:completionHandler];
}

- (NSString*) pathForFilename:(NSString*) filename
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths firstObject];
    NSString* dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return dataPath;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(savedPOIs))];
                NSArray *storedPOIs = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (storedPOIs.count > 0)
                    {
                        NSMutableArray *mutablePOIs = [storedPOIs mutableCopy];
                        
                        [self willChangeValueForKey:@"savedPOIs"];
                        self.savedPOIs = mutablePOIs;
                        [self didChangeValueForKey:@"savedPOIs"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"savedPOIsUpdated" object:nil userInfo:nil];
                        

                    }
                    else{
                        self.savedPOIs = [NSMutableArray new];
                    }
                    
                });
            });
        }
    
    return self;
}

- (void) saveToDisk{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        
//        
//        NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(savedPOIs))];
//        NSData *mediaItemData = [NSKeyedArchiver archivedDataWithRootObject: self.savedPOIs];
//        
//        NSError *dataError;
//        BOOL wroteSuccessfully = [mediaItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
//        
//        if (!wroteSuccessfully) {
//            NSLog(@"Couldn't write file: %@", dataError);
//        }
//    });
}

@end
