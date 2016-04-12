//
//  ModifierMatchController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 01/07/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ModifierMatchController: UITableViewController {

    internal var match: Match!
    internal var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var rows : Int
        switch section {
        case 0:
            rows = 4
        case 1:
            rows = 3
        default:
            rows = 0
        }
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("detailModifier", forIndexPath: indexPath) 
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Résultat"
                if(match.resultat){
                    cell.detailTextLabel?.text = "Victoire"
                }else{
                    cell.detailTextLabel?.text="Défaite"
                }
            case 1:
                cell.textLabel?.text = "WO"
                if(match.wo){
                    cell.detailTextLabel?.text = "Oui"
                }else{
                    cell.detailTextLabel?.text = "Non"
                }
            case 2:
                cell.textLabel?.text = "Format"
                if(match.coef == 1.0){
                    cell.detailTextLabel?.text = "Normal"
                }else{
                    cell.detailTextLabel?.text = "Court"
                }
            case 3:
                cell.textLabel?.text = "Bonus championnat"
                if(match.bonus){
                    cell.detailTextLabel?.text = "Oui"
                }else{
                    cell.detailTextLabel?.text = "Non"
                }
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("detailModifierText", forIndexPath: indexPath) 
                cell.textLabel?.text = "Nom"
                cell.detailTextLabel?.text = match.lastName
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("detailModifierText", forIndexPath: indexPath) 
                cell.textLabel?.text = "Prénom"
                cell.detailTextLabel?.text = match.firstName
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("detailModifier", forIndexPath: indexPath) 
                cell.textLabel?.text = "Classement"
                cell.detailTextLabel?.text = match.classement.string
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("detailModifier", forIndexPath: indexPath) 
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("detailModifier", forIndexPath: indexPath) 
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Match"
        case 1:
            title = "Infos Adversaire"
        default:
            title = ""
        }
        return title
    }
    
    @IBAction func saveMatchChanges(segue:UIStoryboardSegue){
        self.tableView.reloadData()
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell {
            if(segue.identifier == "modifierChoix"){
                let controller = segue.destinationViewController as! ModifierChoixController
                controller.choixType = cell.textLabel?.text
                controller.match = match
                controller.id = id
            }
            else if(segue.identifier == "modifierText"){
                let controller = segue.destinationViewController as! ModifierTextController
                controller.textValue = cell.detailTextLabel?.text
                controller.textType = cell.textLabel?.text
                controller.match = match
                controller.id = id
            }
        }
        else if(segue.identifier == "deleteMatch"){
            if(match.resultat){
                barCtrl.user.victoires.removeAtIndex(id)
            }else{
                barCtrl.user.defaites.removeAtIndex(id)
            }
            barCtrl.clearCoreData()
            barCtrl.fillCoreData()
        }
    }
}
