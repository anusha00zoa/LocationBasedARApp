//
//  Annotation.m
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import "Annotation.h"

#import "Place.h"

@interface Annotation ()
@property (nonatomic, strong) Place *place;
@end

@implementation Annotation

- (id)initWithPlace:(Place *)place {
    if((self = [super init])) {
        _place = place;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return [_place location].coordinate;
}

- (NSString *)title {
    return [_place placeName];
}

@end
