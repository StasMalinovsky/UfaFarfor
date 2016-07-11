//
//  ContactsViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 11.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "ContactsViewController.h"
#import "SWRevealViewController.h"

@interface ContactsViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *citiesArray;
@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSMutableArray *latArray;
@property (strong, nonatomic) NSMutableArray *longArray;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    
    self.sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    self.citiesArray = [self parseJSONWithKey:@"city"];
    self.addressArray = [self parseJSONWithKey:@"address"];
    self.latArray = [self parseJSONWithKey:@"latitude"];
    self.longArray = [self parseJSONWithKey:@"longitude"];
    
    for (int i = 0; i < self.citiesArray.count; i++) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationDegrees latitude = [[self.latArray objectAtIndex:i] doubleValue];
        CLLocationDegrees longitude = [[self.longArray objectAtIndex:i] doubleValue];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        point.coordinate = coord;
        point.title = [NSString stringWithFormat:@"%@", [self.citiesArray objectAtIndex:i]];
        point.subtitle = [NSString stringWithFormat:@"%@", [self.addressArray objectAtIndex:i]];
        [self.mapView addAnnotation:point];
    }
}

#pragma mark - Parse

- (NSMutableArray *)parseJSONWithKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pins" ofType:@"json"];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSData *JSONdata = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONdata options:0 error:&error];
    
    NSArray *namesArray = [dictionary objectForKey:@"pins"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (dictionary in namesArray){
        NSString *name = [dictionary objectForKey:key];
        [mutableArray addObject:name];
    }
    return mutableArray;
}

@end
