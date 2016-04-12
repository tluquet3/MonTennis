//
//  Match.swift
//  MonTennis
//
//  Created by Thomas Luquet on 21/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import Foundation

class Match {
    
    var resultat: Bool
    var firstName: String
    var lastName: String
    var classement: Classement
    var coef: Double
    var bonus: Bool
    var wo: Bool
    
    init(resultat: Bool,firstName: String, lastName:String, classement: Classement,bonus: Bool, coef: Double, wo: Bool ){
        
        self.resultat = resultat
        self.firstName = firstName
        self.lastName = lastName
        self.classement = classement
        self.bonus = bonus
        self.coef = coef
        self.wo = wo
    }
}