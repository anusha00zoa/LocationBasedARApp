//
//  SecondViewController.h
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ARKit/ARKit.h"

@interface SecondViewController : UIViewController <ARLocationDelegate, ARDelegate, ARMarkerDelegate>

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) MKUserLocation *userLocation;

@end
