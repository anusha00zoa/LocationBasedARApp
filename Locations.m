//
//  Locations.m
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import "Locations.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>
#import <UIKit/UIKit.h>
#import "Place.h"

NSString * const apiURL = @"https://maps.googleapis.com/maps/api/place/";
NSString * const apiKey = @"AIzaSyDlEhgtP-1aLS3gjxMCEvcwdD9PAYbn_Zs";

@interface Locations ()

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) ErrorHandler errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation Locations

- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    _responseData = nil;
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    CLLocationDegrees latitude = [location coordinate].latitude;
    CLLocationDegrees longitude = [location coordinate].longitude;
    
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&sensor=true&types=establishment&key=%@", latitude, longitude, radius, apiKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    _responseData = nil;
    _successHandler = handler;
    _errorHandler = errorHandler;
    
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    
    [uri appendFormat:@"details/json?reference=%@&sensor=true&key=%@", [location reference], apiKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_responseData) {
        _responseData = [NSMutableData dataWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    
    if(_successHandler) {
        _successHandler(object);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(_errorHandler) {
        _errorHandler(error);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

