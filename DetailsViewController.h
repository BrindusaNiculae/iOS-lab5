//
//  DetailsViewController.h
//  Places
//
//  Created by ios5 on 7/10/15.
//  Copyright (c) 2015 Brindusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;


@interface DetailsViewController : UIViewController

@property(strong, atomic) GMSPlace *detailsPlace;

@end
