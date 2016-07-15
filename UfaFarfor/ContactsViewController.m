//
//  ContactsViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 11.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "ContactsViewController.h"
#import "SWRevealViewController.h"
#import "ContactsTableViewCell.h"

static NSString *kContactsCellIdentifier = @"ContactsCellIdentifier";

@interface ContactsViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *citiesArray;
@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSMutableArray *latArray;
@property (strong, nonatomic) NSMutableArray *longArray;
@property (strong, nonatomic) NSMutableArray *telephoneArray;
@property (strong, nonatomic) MKPointAnnotation *pin;
@property (strong, nonatomic) NSMutableArray *pinsArray;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerNib];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.citiesArray = [self parseJSONWithKey:@"city"];
    self.addressArray = [self parseJSONWithKey:@"address"];
    self.latArray = [self parseJSONWithKey:@"latitude"];
    self.longArray = [self parseJSONWithKey:@"longitude"];
    self.telephoneArray = [self parseJSONWithKey:@"telephone"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kContactsCellIdentifier];
    
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContactsCellIdentifier];
    }
    
    cell.cityLabel.text = [NSString stringWithFormat:@"%@", [self.citiesArray objectAtIndex:indexPath.row]];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@", [self.addressArray objectAtIndex:indexPath.row]];
    cell.telephoneLabel.text = [NSString stringWithFormat:@"%@", [self.telephoneArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [[self.latArray objectAtIndex:indexPath.row] doubleValue];
    region.center.longitude = [[self.longArray objectAtIndex:indexPath.row] doubleValue];
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
    
}

- (void) registerNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactsTableViewCell" bundle:nil] forCellReuseIdentifier:kContactsCellIdentifier];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    self.pinsArray = [NSMutableArray new];
    
    for (int i = 0; i < self.citiesArray.count; i++) {
        self.pin = [[MKPointAnnotation alloc] init];
        CLLocationDegrees latitude = [[self.latArray objectAtIndex:i] doubleValue];
        CLLocationDegrees longitude = [[self.longArray objectAtIndex:i] doubleValue];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        self.pin.coordinate = coord;
        self.pin.title = [NSString stringWithFormat:@"%@, %@", [self.citiesArray objectAtIndex:i],
                                                            [self.addressArray objectAtIndex:i]];
        self.pin.subtitle = [NSString stringWithFormat:@"%@", [self.telephoneArray objectAtIndex:i]];
        [self.pinsArray addObject:self.pin];
        [self.mapView addAnnotation:self.pin];
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
