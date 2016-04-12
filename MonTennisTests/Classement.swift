//
//  Classement.swift
//  MonTennis
//
//  Created by Thomas Luquet on 21/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import Foundation

class Classement {
    
    var value: Int
    var string: String {
        return self.listeClassements[value]
    }
    
    private let listeClassements = ["NC","40","30/5","30/4","30/3","30/2","30/1","30","15/5","15/4","15/3","15/2","15/1","15","5/6","4/6","3/6","2/6","1/6","0","-2/6","-4/6","-15","N°60-100","N°40-60","1ère Serie"]
    
    init(value: Int){
        self.value = value
    }
    
}