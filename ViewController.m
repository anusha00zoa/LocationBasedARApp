//
//  ViewController.m
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Locations.h"
#import "Place.h"
#import "Annotation.h"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatitudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastLocation = [locations lastObject];
    
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    if(accuracy < 100.0) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
        MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
        
        [_mapView setRegion:region animated:YES];
        
        [[Locations sharedInstance] loadPOIsForLocation:[locations lastObject] radius:1000 successHandler:^(NSDictionary *response) {
            NSLog(@"Response: %@", response);
            [[Locations sharedInstance] loadPOIsForLocation:[locations lastObject] radius:1000 successHandler:^(NSDictionary *response) {
                NSLog(@"Response: %@", response);
                if([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
                    id places = [response objectForKey:@"results"];
                    NSMutableArray *temp = [NSMutableArray array];
                    
                    if([places isKindOfClass:[NSArray class]]) {
                        for(NSDictionary *resultsDict in places) {
                            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatitudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
                            
                            Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]];
                            
                            [temp addObject:currentPlace];
                            
                            Annotation *annotation = [[Annotation alloc] initWithPlace:currentPlace];
                            [_mapView addAnnotation:annotation];
                        }
                    }
                    
                    _locations = [temp copy];
                    
                    NSLog(@"Locations: %@", locations);
                }
            } errorHandler:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        } errorHandler:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [manager stopUpdatingLocation];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"cameraSegue"]) {
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setLocations:_locations];
        [[segue destinationViewController] setUserLocation:[_mapView userLocation]];
    }
    
    
}

@end
