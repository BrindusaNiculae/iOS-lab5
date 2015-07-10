//
//  PositionManager.m
//  Places
//
//  Created by Serban Chiricescu on 09/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "PositionManager.h"

@interface PositionManager()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation PositionManager

+ (PositionManager*)sharedInstance
{
    static PositionManager* _sharedInstance = nil;
    
    if (_sharedInstance == nil)
    {
        _sharedInstance = [[PositionManager alloc] init];
    }
    return _sharedInstance;
}

-(void)requestLocation
{
    if (!_locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    [_delegate myPosition:[locations lastObject]];
}
@end
