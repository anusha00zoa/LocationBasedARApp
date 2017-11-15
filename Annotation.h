//
//  Annotation.h
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Place;

@interface Annotation : NSObject <MKAnnotation>

- (id)initWithPlace:(Place *)place;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;

@end
