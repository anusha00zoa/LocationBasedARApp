//
//  SecondViewController.m
//  ARAppTutorial
//
//  Created by SINGH ANUSHA  on 12/2/16.
//  Copyright © 2016 SINGH ANUSHA . All rights reserved.
//

#import "SecondViewController.h"
#import "Place.h"
#import "MarkerView.h"
#import "Locations.h"


NSString * const kPhoneKey = @"formatted_phone_number";
NSString * const kWebsiteKey = @"website";

const int kInfoViewTag = 1001;

@interface SecondViewController () <MarkerViewDelegate>

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self geoLocations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
    
    [infoView removeFromSuperview];
}


- (void)generateGeoLocations {
    [self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
    
    for(Place *place in _locations) {
        ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
        [coordinate calibrateUsingOrigin:[_userLocation location]];
        
        MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
        [coordinate setDisplayView:markerView];
        
        [_arController addCoordinate:coordinate];
        [_geoLocations addObject:coordinate];
    }
}

- (void)didTouchMarkerView:(MarkerView *)markerView {
    ARGeoCoordinate *tappedCoordinate = [markerView coordinate];
    CLLocation *location = [tappedCoordinate geoLocation];
    
    int index = [_locations indexOfObjectPassingTest:^(Place* obj, NSUInteger index, BOOL *stop) {
        return [[obj location] isEqual:location];
    }];
    
    if(index != NSNotFound) {
        Place *tappedPlace = [_locations objectAtIndex:index];
        [[Locations sharedInstance] loadDetailInformation:tappedPlace successHanlder:^(NSDictionary *response) {

            NSLog(@"Response: %@", response);
            NSDictionary *resultDict = [response objectForKey:@"result"];
            [tappedPlace setPhoneNumber:[resultDict objectForKey:kPhoneKey]];
            [tappedPlace setWebsite:[resultDict objectForKey:kWebsiteKey]];
            [self showInfoViewForPlace:tappedPlace];
        } errorHandler:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}
- (void)showInfoViewForPlace:(Place *)place {
    CGRect frame = [[self view] frame];
    UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 100.0f, frame.size.height - 100.0f)];
    [infoView setCenter:[[self view] center]];
    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [infoView setText:[place infoText]];
    [infoView setTag:kInfoViewTag];
    [infoView setEditable:NO];
    
    [[self view] addSubview:infoView];
}

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

- (void)didTapMarker:(ARGeoCoordinate *)coordinate {
}

- (NSMutableArray *)geoLocations {
    if(!_geoLocations) {
        [self generateGeoLocations];
    }
    return _geoLocations;
}

@end
