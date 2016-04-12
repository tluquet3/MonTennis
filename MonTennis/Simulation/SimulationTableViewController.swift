//
//  SimulationTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 02/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class SimulationTableViewController: UITableViewController {

    private var newClassement : Classement!
    private var classementSup : Classement!
    private var strTestPass : String!
    private var barCtrl : TabBarController!
    private var score1 : Int!
    private var score2 : Int!
    private var maxVictoires: Int!
    private var nbVictoiresPrises : Int!
    private var VE2I5G : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barCtrl = self.tabBarController as! TabBarController
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        newClassement = barCtrl.user.calculerClassement()
        classementSup = Classement(value: self.newClassement.value + 1)
        maxVictoires = barCtrl.user.calcNbVPrisesEnCompte(newClassement)
        score1  = barCtrl.user.calcBilanA(newClassement,nbVictoiresPrises: maxVictoires)
        score2 = barCtrl.user.calcBilanA(classementSup,nbVictoiresPrises:barCtrl.user.calcNbVPrisesEnCompte(classementSup))
        nbVictoiresPrises = min(maxVictoires, barCtrl.user.getNbVictoires()-barCtrl.user.getNbVictoiresWO())
        VE2I5G = barCtrl.user.calcVE2I5G(newClassement)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func imgForFutur()->UIImage? {
        let img: UIImage?
        if(newClassement.value>self.barCtrl.user.classement.value){
            img = UIImage(named: "UpArrow")
        }else if(newClassement.value<self.barCtrl.user.classement.value){
            img = UIImage(named: "DownArrow")
        }else{
            img = UIImage(named: "EqualSign")
        }
        return img
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let result:Int
        
        if(section == 0){
            result = 1
        }else if(section == 1){
            result = 4 + self.barCtrl.user.getNbMalus(newClassement)
        }
        else if(section == 2){
            result =  nbVictoiresPrises
        }
        else if(section == 3){
            result =  4
        }
        else{
            result = 0
        }
        return result
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("futurClassementCell", forIndexPath: indexPath) as! FuturClassementCell
            cell.futurClassement.text = newClassement.string
            cell.bilan1Label.text = "Bilan à " + newClassement.string + ":"
            cell.bilan2Label.text = "Bilan à " + classementSup.string + ":"
            cell.score1.text = String(score1) + "/" + String(barCtrl.user.norme[newClassement.value].0) + " pts"
            cell.score2.text = String(score2) + "/" + String(barCtrl.user.norme[classementSup.value].0) + " pts"
            cell.progress1.progress = min(Float(score1)/Float(barCtrl.user.norme[newClassement.value].0),1.0)
            cell.progress2.progress = min(Float(score2)/Float(barCtrl.user.norme[classementSup.value].0),1.0)
            cell.imgView.image = self.imgForFutur()
            return cell
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCalculCell", forIndexPath: indexPath) as! DetailCalculCell
            cell.option.text = ""
            switch indexPath.row{
            case 0:
                cell.titre.text = "Bilan total:"
                cell.resultat.text = String(score1) + " pts"
            case 1:
                cell.titre.text = "Victoires:"
                cell.option.text =  "Max: " + String(self.maxVictoires) + " prises en compte"
                cell.resultat.text = String(barCtrl.user.calcGainVictoires(newClassement, nbVictoires: maxVictoires)) + " pts"
            case 2:
                cell.titre.text = "Bonus:"
                cell.option.text = "Championnat"
                cell.resultat.text = String(barCtrl.user.calculerBonusChampionnat()) + " pts"
            case 3:
                cell.titre.text = "Bonus:"
                cell.option.text = "Pas de défaites significatives"
                cell.resultat.text = String(barCtrl.user.calculerBonusAbsenceDefaitesSign(newClassement.value)) + " pts"
            case 4:
                cell.titre.text = "Malus:"
                if(barCtrl.user.getNbWO()>=5){
                    cell.option.text = "Nb defaites par W0 supérieur à 5"
                }else{
                    cell.option.text = "V-E-2I-5G < -100"
                }
                if(barCtrl.user.getNbMalus(newClassement) == 1){
                    cell.resultat.text = Classement(value: newClassement.value+1).string + "->" + newClassement.string
                }else{
                    cell.resultat.text = Classement(value: newClassement.value+2).string + "->" + Classement(value: newClassement.value+1).string
                }
            case 5:
                cell.titre.text = "Malus:"
                cell.option.text = "V-E-2I-5G < -100"
                cell.resultat.text = Classement(value: newClassement.value+1).string + "->" + newClassement.string
            default:
                cell.textLabel?.text = ""
            }
            return cell
        }
        else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCalculCell", forIndexPath: indexPath) as! DetailCalculCell
            let victoire = barCtrl.user.victoires[indexPath.row]
            cell.titre.text = victoire.lastName + " " + victoire.firstName
            cell.option.text = victoire.classement.string
            cell.resultat.text = String(barCtrl.user.calcGainMatch(newClassement, victoire: victoire)) + " pts"
            return cell
        }
        else if(indexPath.section == 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCalculCell", forIndexPath: indexPath) as! DetailCalculCell
            switch indexPath.row{
            case 0:
                cell.titre.text = "Nb Victoires de base:"
                cell.option.text = "A " + newClassement.string
                cell.resultat.text = String(barCtrl.user.norme[newClassement.value].1)
            case 1:
                cell.titre.text = "V-E-2I-5G:"
                cell.resultat.text = String(VE2I5G)
                let V = barCtrl.user.getNbVictoires()
                let E = barCtrl.user.getNbDefaitesA(newClassement.value)
                let I = barCtrl.user.getNbDefaitesA(newClassement.value-1)
                let G = barCtrl.user.getNbDefaitesInfA(newClassement.value-2)
                cell.option.text = "V="+String(V)+", E="+String(E)+", I="+String(I)+", G="+String(G)
            case 2:
                cell.titre.text = "Victoires Supp"
                cell.option.text = ""
                let supp = barCtrl.user.getVfromVE2I5G(newClassement, VE2I5G: VE2I5G)
                var sign = "+"
                if(supp<0){
                    sign = ""
                }
                cell.resultat.text = sign+String(supp)
            case 3:
                cell.titre.text = "Total:"
                cell.option.text = "Max Victoires Prises En Compte"
                cell.resultat.text = String(maxVictoires)
            default:
                cell.titre.text = ""
                cell.resultat.text = ""
                cell.option.text = ""
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCalculCell", forIndexPath: indexPath) as! DetailCalculCell
            return cell
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat  {
        if(indexPath.section == 0){
            return 150
        }
        else{
            return 44
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if(section == 0){
            title = "Bilan"
        }
        else if(section == 1){
            title = "Détail"
        }
        else if( section == 2){
            title = "Victoires Prises en Compte (" + String(self.nbVictoiresPrises) + ")"
        }
        else if(section == 3){
            title = "Détail Victoires Prises en Compte"
        }
        return title
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
