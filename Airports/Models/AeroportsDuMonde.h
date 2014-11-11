//
//  AirportsOfTheWorld.h
//  AeroportsDuMonde
//
//  Classe chargeant les données d'aéroports du fichier de données airports.txt
//  et transformant chaque ligne de ce fichier en une instance de Aeroport.
//
//  La classe offre deux types d'accès aux instances d'Aeroport obtenues:
//     1) via un NSArray d'instances
//     2) via un NSDictionary où les instances sont regroupées selon
//        leur première lettre de leur attribut code
//
//  Created by Marco Lavoie on 2014-11-07.
//  Copyright (c) 2014 Marco Lavoie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AeroportsDuMonde : NSObject

@property (strong, nonatomic) NSArray      *listeAeroports;         // liste des aéroports extraites du fichier
@property (strong, nonatomic) NSDictionary *dictionnaireAeroports;  // aéroports regroupées selon la première lettre de leur code

@end
