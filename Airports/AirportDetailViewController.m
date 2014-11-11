//
//  AirportDetailViewController.m
//  GlobalAir
//
//  Created by Mathieu White on 2014-11-10.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "AirportDetailViewController.h"
#import "MapTableViewCell.h"

@interface AirportDetailViewController () 

@property (nonatomic, strong) Aeroport *airport;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *mapContainer;
@property (nonatomic, weak) MKMapView *mapView;

@end

@implementation AirportDetailViewController

#pragma mark - Initialization

- (instancetype) initWithAirport: (Aeroport *) airport
{
    self = [super init];
    
    if (self)
    {
        _airport = airport;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar Title
    [self setTitle: [self.airport nom]];
    
    // Background Color
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    // Initialize the table view
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor: [UIColor clearColor]];
    [tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [tableView setDelegate: self];
    [tableView setDataSource: self];
    
    // Add each component to the view
    [self.view addSubview: tableView];
    
    // Set each component to a property
    [self setTableView: tableView];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    
    //[self setupMapView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Instance Methods

- (void) setupMapView
{
    // Initialize a map view
    MKMapView *mapView = [[MKMapView alloc] init];
    [mapView setUserInteractionEnabled: NO];
    [mapView setShowsPointsOfInterest: NO];
    [mapView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [mapView setDelegate: self];
    
    // Set the region to the airport location
    MKCoordinateRegion airportRegion = MKCoordinateRegionMakeWithDistance([self.airport coordonnees], 140, 140);
    [mapView setRegion: airportRegion animated: NO];
    
    // Add the point annotation
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate: [self.airport coordonnees]];
    [mapView addAnnotation: pin];
    
    [self.mapContainer addSubview: mapView];
    
    // Map View Auto Layout
    NSDictionary *views = @{@"mapView" : mapView};
    
    NSArray *mapHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[mapView]|"
                                                                                options: 0
                                                                                metrics: nil
                                                                                  views: views];
    
    NSArray *mapVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[mapView]|"
                                                                              options: 0
                                                                              metrics: nil
                                                                                views: views];
    
    [self.mapContainer addConstraints: mapHorizontalConstraints];
    [self.mapContainer addConstraints: mapVerticalConstraints];
    
    [self setMapView: mapView];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    NSDictionary *views = @{@"tableView" : [self tableView]};
    
    NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[tableView]|"
                                                                                      options: 0
                                                                                      metrics: nil
                                                                                        views: views];
    
    NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[tableView]|"
                                                                                    options: 0
                                                                                    metrics: nil
                                                                                      views: views];
    
    [self.view addConstraints: tableViewHorizontalConstraints];
    [self.view addConstraints: tableViewVerticalConstraints];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 3;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    if (section == 0)
        return 3;
    
    if (section == 1)
        return 2;
    
    if (section == 2)
        return 3;
    
    return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier];
    
    if ([indexPath section] == 0)
    {
        if ([indexPath row] == 0)
        {
            [cell.textLabel setText: NSLocalizedString(@"ID", nil)];
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"%ld", (long) [self.airport ident]]];
        }
        if ([indexPath row] == 1)
        {
            [cell.textLabel setText: NSLocalizedString(@"Code", nil)];
            [cell.detailTextLabel setText: [self.airport code]];
        }
        if ([indexPath row] == 2)
        {
            [cell.textLabel setText: NSLocalizedString(@"Name", nil)];
            [cell.detailTextLabel setText: [self.airport nom]];
        }
    }
    
    else if ([indexPath section] == 1)
    {
        if ([indexPath row] == 0)
        {
            [cell.textLabel setText: NSLocalizedString(@"City", nil)];
            [cell.detailTextLabel setText: [self.airport ville]];
        }
        if ([indexPath row] == 1)
        {
            [cell.textLabel setText: NSLocalizedString(@"Country", nil)];
            [cell.detailTextLabel setText: [self.airport pays]];
        }
    }
    
    else if ([indexPath section] == 2)
    {
        if ([indexPath row] == 0)
        {
            [cell.textLabel setText: NSLocalizedString(@"Latitude", nil)];
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"%f", self.airport.coordonnees.latitude]];
        }
        if ([indexPath row] == 1)
        {
            [cell.textLabel setText: NSLocalizedString(@"Longitude", nil)];
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"%f", self.airport.coordonnees.longitude]];
        }
        if ([indexPath row] == 2)
        {
            MapTableViewCell *mapCell = [[MapTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MapCell"];
            
            [mapCell setCoordinates: [self.airport coordonnees]];
            
            return mapCell;
        }
    }
    
    return cell;
}

- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger) section
{
    if (section == 0)
        return NSLocalizedString(@"Identification", nil);
    
    if (section == 1)
        return NSLocalizedString(@"Geographic Data", nil);
    
    if (section == 2)
        return NSLocalizedString(@"Geolocation", nil);
    
    return nil;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if ([indexPath section] == 2 && [indexPath row] == 2)
        return 320.0f;
    
    return 48.0f;
}

- (CGFloat) tableView: (UITableView *) tableView heightForFooterInSection: (NSInteger) section
{
    if (section == 0)
        return 24.0f;
    
    if (section == 1)
        return 24.0f;
    
    return 0.0f;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView *) mapView: (MKMapView *) map viewForAnnotation: (id <MKAnnotation>) annotation
{
    // User location annotation
    if ([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    
    return nil;
}

@end
