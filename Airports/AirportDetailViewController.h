//
//  AirportDetailViewController.h
//  GlobalAir
//
//  Created by Mathieu White on 2014-11-10.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

@import MapKit;

#import <UIKit/UIKit.h>
#import "Aeroport.h"

@interface AirportDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

- (instancetype) initWithAirport: (Aeroport *) airport;

@end
