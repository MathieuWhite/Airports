//
//  Airport.m
//  AeroportsDuMonde
//
//  Classe stockant les données relatives à un aéroport.
//
//  Created by Marco Lavoie on 2014-11-07.
//  Copyright (c) 2014 Marco Lavoie. All rights reserved.
//

#import "Aeroport.h"

@implementation Aeroport

// Initialiseur paramétré avec la ligne de données contenant toutes les données relatives
// à un aéroport. Notez que l'initialiseur exploite la fonction utilitaire eliminerGuillemets:
// car plusieurs champs de ligneDonnees sont englobés dans des guillemets doubles (voir le
// fichier d'où sont obtenues ces données).
- (id)initAvecLigneDonnees:(NSString *)ligneDonnees {
    self = [super init];
    
    if (self) {
        // Décomposer la ligne de données en champs (un champ par donnée)
        NSArray *champs = [ligneDonnees componentsSeparatedByString:@","];

        // Extraire le numéro d'identification OpenFlights
        self.ident   = [[self eliminerGuillemets:champs[0]] integerValue];
        
        // Extraire le code IATA/FAA. Si aucun code n'est fourni, essayer le code ICAO
        self.code    = [self eliminerGuillemets:champs[4]];
        if ([self.code length] == 0)
            self.code = [self eliminerGuillemets:champs[5]];
        
        // Extraire les données générales
        self.nom    = [self eliminerGuillemets:champs[1]];
        self.ville    = [self eliminerGuillemets:champs[2]];
        self.pays = [self eliminerGuillemets:champs[3]];

        // Extraire les données de géolocalisation
        CLLocationDegrees latitude = [[self eliminerGuillemets:champs[6]] floatValue];
        CLLocationDegrees longitude = [[self eliminerGuillemets:champs[7]] floatValue];
        self.coordonnees = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    return self;
}

// Fonction utilitaire retirant de la chaîne fournie toutes les guillements doubles
- (NSString *)eliminerGuillemets:(NSString *)chaine {
    return [chaine stringByReplacingOccurrencesOfString:@"\""
                                             withString:@""
                                                options:NSCaseInsensitiveSearch
                                                  range:NSMakeRange(0, [chaine length])];
}

@end
