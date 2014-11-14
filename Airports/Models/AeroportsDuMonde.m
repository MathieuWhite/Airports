//
//  AirportsOfTheWorld.m
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

#import "AeroportsDuMonde.h"
#import "Aeroport.h"

@interface AeroportsDuMonde()

@end

@implementation AeroportsDuMonde

// Accesseur de propriété (lazy instanciation) extrayant les données du fichier de données au besoin
- (NSArray *)listeAeroports
{
    if (!_listeAeroports)
        _listeAeroports = [self chargerDonneesAeroports];
    
    return _listeAeroports;
}

// Accesseur de propriété (lazy instanciation) regroupant les aéroports de sa liste selon la
// première lettre de leur code IATA/FAA. Ce dictionnaire est particulièrement pratique pour
// afficher un index d'aéroports dans un UITableView listant celles-ci.
- (NSDictionary *)dictionnaireAeroports {
    if (!_dictionnaireAeroports)
        _dictionnaireAeroports = [self classifierDonneesAeroports];
    
    return _dictionnaireAeroports;
}

// Fonction utilitaire chargeant les données d'aéroprts du fichier de données airports.txt.
// La fonction retourne les instances de Aeroport créés à partir de ces données dans un
// NSArray.
- (NSArray *)chargerDonneesAeroports {
    // Charger toutes les données du fichier dans un NSString
    NSString *path = [[NSBundle mainBundle] pathForResource:@"airports" ofType:@"txt"];
    NSString *contenu = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    // Convertir chaque ligne lue en une instance de Aeroport initialisée avec les données
    // de cette ligne
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *ligne in [contenu componentsSeparatedByString:@"\n"]) {
        Aeroport *ap = [[Aeroport alloc] initAvecLigneDonnees:ligne];
        
        if ([ap.code length] > 0)
            [arr addObject:ap];
    }
    
    // Sort the array by airport code
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey: @"code" ascending: YES];
    NSArray *descriptor = [NSArray arrayWithObject: valueDescriptor];
    NSArray *sortedArray = [arr sortedArrayUsingDescriptors: descriptor];
    
    return sortedArray;
}

// Créer un dictionnaire à partir de la liste d'aéroports lues du fichier de données. Ce dictionnaire
// regroupe les instances de Aeroport aelon la première lettre de leur code IATA/FAA (p.ex. pour la
// clé @"Y", la valeur associée est un NSArray contenant toutes les instances de Aeroport dont le code
// commence par Y).
// Un tel dictionnaire est particulièrement utile lorsque les aéroports doivent être affichées dans
// un ITableView et regroupées selon la première lettre de leur code IATA/FAA. Un tel regroupement
// premet d'afficher un index d'accès rapide au UITableView.
- (NSDictionary *)classifierDonneesAeroports {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (Aeroport *airport in self.listeAeroports) {
        // Extraire la première lettre du code IATA/FAA de l'aéroport
        NSString *firstLetter = [[airport.code substringToIndex:1] uppercaseString];
        
        // Put all the numbers in the same key
        if ([firstLetter integerValue] || [firstLetter isEqualToString: @"0"])
            firstLetter = @"#";
        
        // Si le dictionnaire ne contient pas encore une paire associée à cette lettre,
        // la créer. Sinon ajouter l'aéroport à la valeur de clé existante
        NSMutableArray *airports = [dic valueForKey:firstLetter];
        if (!airports)
            dic[firstLetter] = [@[airport] mutableCopy];
        else
            [dic[firstLetter] addObject: airport];
    }
    
    return dic;
}

@end
