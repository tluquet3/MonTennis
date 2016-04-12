//
//  Utilisateur.swift
//  MonTennis
//
//  Created by Thomas Luquet on 21/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import Foundation

class Utilisateur{
    
    var prenom: String
    var nom: String
    var sexe: Bool{
        didSet {
            if(self.sexe){
                self.norme = self.normesM
            }else{
                self.norme = self.normesF
            }
        }
    }
    var classement: Classement
    var victoires: [Match]
    var defaites:[Match]
    var norme: [(Int,Int)]
    var club : String
    
    private let normesF = [(0,6),(0,6),(6,6),(70,6),(120,6),(170,6),(210,6),(260,8),(290,8),(300,8),(310,8),(330,8),(350,8),(390,9),(400,9),(430,9),(490,10),(550,11),(600,12),(620,14),(750,15),(750,16),(800,17),(850,17),(910,19)]
    private let normesM = [(0,6),(0,6),(6,6),(70,6),(120,6),(170,6),(210,6),(280,8),(300,8),(310,8),(320,8),(340,8),(370,8),(425,9),(430,9),(430,9),(460,10),(490,10),(540,11),(600,12),(750,15),(850,17),(950,19),(1000,20),(1110,22)]
    
    init(firstName: String, lastName: String, classement: Classement, sex:Bool, club: String){
        self.prenom = firstName
        self.nom = lastName
        self.classement = classement
        self.victoires = [Match]()
        self.defaites = [Match]()
        self.norme = normesM
        self.sexe = sex
        self.club = club
    }
    
    func ajoutMatch(match: Match)->Int{
        var tableau: [Match]
        var i = 0
        if(match.resultat){
            tableau = victoires
        }else{
            tableau = defaites
        }
        if(tableau.count != 0){
            if( match.wo){ // Find the index of the first wo
                while(i<tableau.count && !tableau[i].wo){
                    i += 1
                }
            }
            while(i<tableau.count && tableau[i].classement.value > match.classement.value && !tableau[i].wo){
                i += 1
            }
        }
        if(match.resultat){
            victoires.insert(match,atIndex: i)
        }else{
            defaites.insert(match,atIndex: i)
        }
        return i
    }
    
    func calculerClassement() -> Classement {
        let newClassement = Classement(value: self.classement.value)
        var victoiresComptees: Int
        var bilan: Int
        if(victoires.count > 0){
            let pMax : Int
            if(self.classement.value < 7){ // Si en 4e serie, pmax: +2
                pMax = min(max(victoires[0].classement.value + 2,self.classement.value+2),norme.count-1)
            }else{//Sinon pmax: +1
                pMax = min(max(victoires[0].classement.value + 1,self.classement.value+1),norme.count-1)
            }
            var maintien = false
            newClassement.value = pMax
            while( !maintien && newClassement.value>self.classement.value-1){
                victoiresComptees = calcNbVPrisesEnCompte(newClassement)
                bilan = calcBilanA(newClassement, nbVictoiresPrises: victoiresComptees)
                if(bilan>norme[newClassement.value].0){
                    maintien = true
                }else{
                    newClassement.value -= 1
                }
            }
        }else{
            if(self.classement.value>1){
                newClassement.value -= 1
            }
        }
        if(getNbWO()>=5 && self.classement.value>0){   //A partir de 5 WO, on perd un classement
            newClassement.value -= 1
        }
        if(newClassement.value>=13 && calcVE2I5G(newClassement) < (-99)){ //Uniquement pour les 2e series
            newClassement.value -= 1
        }
        return newClassement
    }
    func calcBilanA(echelon:Classement,nbVictoiresPrises:Int)-> Int{
        var bilan = calcGainVictoires(echelon, nbVictoires: nbVictoiresPrises)
        var totalBonus = 0
        totalBonus += calculerBonusChampionnat()
        totalBonus += calculerBonusAbsenceDefaitesSign(echelon.value)
        bilan += totalBonus
        return bilan
    }
    func calcVE2I5G(echelon:Classement) -> Int { // Prendre En compte Les coefs
        let V = victoires.count
        let E = getNbDefaitesA(echelon.value)
        let I = getNbDefaitesA(echelon.value-1)
        let G = getNbDefaitesInfA(echelon.value-2)
        return V-E-2*I-5*G
    }
    func calcGainVictoires(echelon:Classement,nbVictoires:Int) -> Int{
        var i = 0
        var bilan = 0
        var totalV: Double = 0.0
        var nbVReel = 0
        while(totalV<Double(nbVictoires) && i<self.victoires.count ){
            if(!victoires[i].wo){
                let coef = victoires[i].coef
                var points: Int
                switch victoires[i].classement.value {
                case echelon.value+1:
                    points = 90
                case echelon.value:
                    points = 60
                case echelon.value-1:
                    points = 30
                case echelon.value-2:
                    points = 20
                case echelon.value-3:
                    points = 15
                default:
                    if(victoires[i].classement.value < echelon.value-3){
                        points = 0
                    }else{
                        points = 120
                    }
                }
                points = Int(Double(points)*coef)
                bilan += points
                totalV += coef
                nbVReel += 1
            }
            i += 1
        }
        return bilan
    }
    func calcGainMatch(echelon:Classement,victoire:Match)->Int{
        var points = 0
        if(!victoire.wo){
            let coef = victoire.coef
            switch victoire.classement.value {
            case echelon.value+1:
                points = 90
            case echelon.value:
                points = 60
            case echelon.value-1:
                points = 30
            case echelon.value-2:
                points = 20
            case echelon.value-3:
                points = 15
            default:
                if(victoire.classement.value < echelon.value-3){
                    points = 0
                }else{
                    points = 120
                }
            }
            points = Int(Double(points)*coef)
        }
        return points
    }
    func calcNbVPrisesEnCompte(echelon: Classement) -> Int{
        let nbVictoiresAEchelon: Int
        let nbVictoiresSup:Int
        // Nb victoires prises en compte a l'echelon
        nbVictoiresAEchelon = self.norme[echelon.value].1
        // Nb victoires sup grace au V-E-2I-5G
        let VE2I5G = calcVE2I5G(echelon)
        nbVictoiresSup = getVfromVE2I5G(echelon, VE2I5G: VE2I5G)
        return nbVictoiresAEchelon+nbVictoiresSup
    }
    func getVfromVE2I5G(echelon:Classement,VE2I5G:Int)->Int{
        var nbVictoiresSup = 0
        switch echelon.value{
        case 0...6: //4E Serie
            switch VE2I5G{
            case 0...4:
                nbVictoiresSup = 1
            case 5...9:
                nbVictoiresSup = 2
            case 10...14:
                nbVictoiresSup = 3
            case 15...19:
                nbVictoiresSup = 4
            case 20...24:
                nbVictoiresSup = 5
            default:
                if(VE2I5G>=25){
                    nbVictoiresSup = 6
                }else{
                    nbVictoiresSup = 0
                }
            }
        case 7...12: //3E Serie
            switch VE2I5G{
            case 0...7:
                nbVictoiresSup = 1
            case 8...14:
                nbVictoiresSup = 2
            case 15...22:
                nbVictoiresSup = 3
            case 23...29:
                nbVictoiresSup = 4
            case 30...39:
                nbVictoiresSup = 5
            default:
                if(VE2I5G>=40){
                    nbVictoiresSup = 6
                }else{
                    nbVictoiresSup = 0
                }
            }
        case 13...19: //2E Serie +
            switch VE2I5G{
            case (-40)...(-31):
                nbVictoiresSup = -2
            case (-30)...(-21):
                nbVictoiresSup = -1
            case (-20)...(-1):
                nbVictoiresSup = 0
            case 0...7:
                nbVictoiresSup = 1
            case 8...14:
                nbVictoiresSup = 2
            case 15...22:
                nbVictoiresSup = 3
            case 23...29:
                nbVictoiresSup = 4
            case 30...39:
                nbVictoiresSup = 5
            default:
                if(VE2I5G<(-40)){
                    nbVictoiresSup = -3
                }else{
                    nbVictoiresSup = +6
                }
            }
        default: //2E Serie-
            switch VE2I5G{
            case (-80)...(-61):
                nbVictoiresSup = -4
            case (-60)...(-41):
                nbVictoiresSup = -3
            case (-40)...(-31):
                nbVictoiresSup = -2
            case (-30)...(-21):
                nbVictoiresSup = -1
            case (-20)...(-1):
                nbVictoiresSup = 0
            case 0...9:
                nbVictoiresSup = 1
            case 10...19:
                nbVictoiresSup = 2
            case 20...24:
                nbVictoiresSup = 3
            case 25...29:
                nbVictoiresSup = 4
            case 30...34:
                nbVictoiresSup = 5
            case 35...44:
                nbVictoiresSup = 6
            default:
                if(VE2I5G<(-81)){
                    nbVictoiresSup = -5
                }else{
                    nbVictoiresSup = 7
                }
            }
        }
        return nbVictoiresSup
    }
    func calculerBonusChampionnat() -> Int{
        var bonus = 0
        for match in victoires{
            if(match.bonus){
                bonus += 15
            }
        }
        bonus = min(bonus,45)
        return bonus
    }
    func calculerBonusAbsenceDefaitesSign(echelon:Int) -> Int{
        var bonus = 0
        // Bonus pour absence de defaites a echelon egal ou inf (a partir de 30/2)
        if(echelon >= 5 && getNbDefaitesInfA(echelon) == 0 && getNbMatchsSansWOBonus()>=5){
            switch echelon {
            case 5...6:
                bonus+=50
            case 7...12:
                bonus+=100
            default:
                bonus+=150
            }
        }
        return bonus
    }
    func viderPalmares(){
        victoires = [Match]()
        defaites = [Match]()
    }
    func getNbMatchs() -> Int{
        return victoires.count + defaites.count
    }
    func getNbMatchsSansWOBonus()->Int{
        return victoires.count - getNbVictoiresWO() + defaites.count - getNbWO()
    }
    func getNbVictoires() -> Int{
        return victoires.count
    }
    func getNbVictoiresWO() -> Int{
        var result = 0
        for match in victoires{
            if(match.wo){
                result += 1
            }
        }
        return result
    }
    func getNbDefaites() -> Int{
        return defaites.count
    }
    func getNbDefaitesA(echelon: Int) -> Int {
        var result = 0
        for match in defaites{
            if(match.classement.value == echelon && !match.wo){
                result += 1
            }
        }
        return result
    }
    func getNbDefaitesInfA(echelon:Int)->Int{
        var result = 0
        for match in defaites{
            if(match.classement.value <= echelon && !match.wo){
                result += 1
            }
        }
        // A partir du 3eme WO, chaque WO est considere comme un defaite a echelon inf
        let nbWO = getNbWO()
        if( nbWO > 2 ){
            result += nbWO-2
        }
        return result
    }
    func getNbWO()->Int{
        var result = 0
        for match in defaites{
            if(match.wo){
                result += 1
            }
        }
        return result
    }
    func getNbMalus(newClassement:Classement)->Int{
        var nbMalus = 0
        if(newClassement.value>0 && getNbWO()>=5){   //A partir de 5 WO, on perd un classement
            nbMalus += 1
        }
        if(newClassement.value>=13 && calcVE2I5G(newClassement) < (-99)){ //Uniquement pour les 2e series
           nbMalus += 1
        }
        return nbMalus
    }
}