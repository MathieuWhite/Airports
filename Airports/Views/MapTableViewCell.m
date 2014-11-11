//
//  MapTableViewCell.m
//  GlobalAir
//
//  Created by Mathieu White on 2014-11-10.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "MapTableViewCell.h"

@interface MapTableViewCell ()

@property (nonatomic, weak) MKMapView *mapView;

@end

@implementation MapTableViewCell

#pragma mark - Initialization

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    
    if (self)
    {
        [self initMapTableViewCell];
    }
    
    return self;
}

- (void) initMapTableViewCell
{
    // Initialize the map view
    MKMapView *mapView = [[MKMapView alloc] init];
    [mapView setMapType: MKMapTypeSatellite];
    [mapView setScrollEnabled: NO];
    [mapView setZoomEnabled: NO];
    [mapView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [mapView setDelegate: self];
    
    [self.contentView addSubview: mapView];
    
    [self setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    [self setMapView: mapView];
    
    [self setupConstraints];
}

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
    [super setSelected: selected animated: animated];
}

- (void) setCoordinates: (CLLocationCoordinate2D) coordinates
{
    // Set the region to the airport location
    MKCoordinateRegion serviceRegion = MKCoordinateRegionMakeWithDistance(coordinates, 2000, 2000);
    [self.mapView setRegion: serviceRegion animated: NO];
    
    // Add the point annotation
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate: coordinates];
    [self.mapView addAnnotation: pin];
    
    _coordinates = coordinates;
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    NSDictionary *views = @{@"mapView" : [self mapView]};
    
    NSArray *mapViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[mapView]|"
                                                                                    options: 0
                                                                                    metrics: nil
                                                                                      views: views];
    
    NSArray *mapViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[mapView]|"
                                                                                  options: 0
                                                                                  metrics: nil
                                                                                    views: views];
    
    [self.contentView addConstraints: mapViewHorizontalConstraints];
    [self.contentView addConstraints: mapViewVerticalConstraints];
}

@end
