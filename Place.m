//
//  Place.m
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address {
    if((self = [super init])) {
        _location = location;
        _reference = reference;
        _placeName = name;
        _address = address;
    }
    return self;
}

- (NSString *)infoText {
    return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@", _placeName, _address, _phoneNumber, _website];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Name:%@, location:%@", [super description], _placeName, _location];
}

@end
