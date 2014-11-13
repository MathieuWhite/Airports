//
//  Airport.h
//  AeroportsDuMonde
//
//  Classe stockant les données relatives à un aéroport.
//
//  Created by Marco Lavoie on 2014-11-07.
//  Copyright (c) 2014 Marco Lavoie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Aeroport : NSObject

@property (nonatomic) NSInteger ident;          // identificateur OpenFlights

@property (nonatomic, copy) NSString *nom;    // nom de l'aéroport
@property (nonatomic, copy) NSString *code;   // code IATA ou FAA
@property (nonatomic, copy) NSString *ville;  // ville où est située l'aéroport
@property (nonatomic, copy) NSString *pays;   // pays où est située l'aéroport

@property (nonatomic, readwrite) CLLocationCoordinate2D coordonnees;   // coordonnées géographiques

// Initialiseur paramétré avec la ligne de données contenant toutes les données relatives
// à un aéroport.
- (id)initAvecLigneDonnees:(NSString *)ligneDonnees;

@end
