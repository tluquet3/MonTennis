//
//  ModifierChoixController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 03/07/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ModifierChoixController: UITableViewController {
    
    internal var choixType: String!
    internal var match: Match!
    internal var id: Int!
    private let pickerData = ["NC","40","30/5","30/4","30/3","30/2","30/1","30","15/5","15/4","15/3","15/2","15/1","15","5/6","4/6","3/6","2/6","1/6","0","-2/6","-4/6","-15","N°60-100","N°40-60","1ère Serie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = choixType
        let indexPath = NSIndexPath(forRow: selectedRow(), inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let rows: Int
        switch choixType {
        case "Classement":
            rows = pickerData.count
        default :
            rows = 2
        }
        return rows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("choixCell", forIndexPath: indexPath) 
        switch choixType {
        case "Classement":
            cell.textLabel?.text = pickerData[indexPath.row]
        case "Résultat":
            if(indexPath.row == 0){
                cell.textLabel?.text = "Victoire"
            }else{
                cell.textLabel?.text = "Défaite"
            }
        case "Format":
            if(indexPath.row == 0){
                cell.textLabel?.text = "Normal"
            }else{
                cell.textLabel?.text = "Court"
            }
        default:
            if(indexPath.row == 0){
                cell.textLabel?.text = "Oui"
            }else{
                cell.textLabel?.text = "Non"
            }
         }
        if(indexPath.row == selectedRow()){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        return cell
    }
    
    private func selectedRow()->Int{
        var row = 0
        switch choixType {
        case "Résultat":
            if(!match.resultat){
                row = 1
            }
        case "WO":
            if(!match.wo){
                row = 1
            }
        case "Bonus championnat":
            if(!match.bonus){
                row = 1
            }
        case "Format":
            if(match.coef == 0.6){
                row = 1
            }
        case "Classement":
            row = match.classement.value
        default :
            row = 0
        
        }
        return row
    }
   
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell{
            var newId = self.id
            if( match.resultat){
                switch choixType {
                case "Résultat":
                    if(cell.textLabel?.text == "Défaite"){
                        barCtrl.user.victoires.removeAtIndex(id)
                        self.match.resultat = false
                        newId = barCtrl.user.ajoutMatch(self.match)
                    }
                case "WO":
                    barCtrl.user.victoires[id].wo = (cell.textLabel?.text == "Oui")
                case "Bonus championnat":
                    barCtrl.user.victoires[id].bonus = (cell.textLabel?.text == "Oui")
                case "Classement":
                    barCtrl.user.victoires.removeAtIndex(id)
                    let text = cell.textLabel?.text
                    self.match.classement = Classement(stringValue: text!)
                    newId = barCtrl.user.ajoutMatch(self.match)
                case "Format":
                    barCtrl.user.victoires.removeAtIndex(id)
                    let text = cell.textLabel?.text
                    if(text == "Normal"){
                        self.match.coef = 1.0
                    }else{
                        self.match.coef = 0.6
                    }
                    newId = barCtrl.user.ajoutMatch(self.match)
                default:
                    print("Unable to find the corresponding string", terminator: "")
                }
            }else{
                switch choixType {
                case "Résultat":
                    if(cell.textLabel?.text == "Victoire"){
                        barCtrl.user.defaites.removeAtIndex(id)
                        self.match.resultat = true
                        newId = barCtrl.user.ajoutMatch(self.match)
                    }
                case "WO":
                    barCtrl.user.defaites[id].wo = (cell.textLabel?.text == "Oui")
                case "Bonus championnat":
                    barCtrl.user.defaites[id].bonus = (cell.textLabel?.text == "Oui")
                case "Classement":
                    barCtrl.user.defaites.removeAtIndex(id)
                    let text = cell.textLabel?.text
                    self.match.classement = Classement(stringValue: text!)
                    newId = barCtrl.user.ajoutMatch(self.match)
                case "Format":
                    barCtrl.user.defaites.removeAtIndex(id)
                    let text = cell.textLabel?.text
                    if(text == "Normal"){
                        self.match.coef = 1.0
                    }else{
                        self.match.coef = 0.6
                    }
                    newId = barCtrl.user.ajoutMatch(self.match)
                default:
                    print("Unable to find the corresponding string", terminator: "")
                }
            }
            barCtrl.clearCoreData()
            barCtrl.fillCoreData()
            let destCtrl = segue.destinationViewController as! ModifierMatchController
            destCtrl.id = newId
            
        }
        
    }
    
}

