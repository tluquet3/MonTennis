//
//  PalmaresTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 27/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit
import CoreData

class PalmaresTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func deletePalmares(sender: AnyObject) {
        let alert = UIAlertController(title: "Supprimer Palmares?", message: "Tout le palmares sera supprimé", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action: UIAlertAction) in
            barCtrl.user.viderPalmares()
            barCtrl.clearCoreData()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .Default, handler: {
            (action: UIAlertAction) in
        }))
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelToPalmaresViewController(segue:UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    @IBAction func saveMatchDetails(segue:UIStoryboardSegue) {
        if let ajoutMatchViewController = segue.sourceViewController as? AjoutMatchViewController {
            //add the new match to the match array
            barCtrl.user.ajoutMatch(ajoutMatchViewController.match)
            
            //Update the coreData
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let entity =  NSEntityDescription.entityForName("Match",
                inManagedObjectContext:
                managedContext)
            let match = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            match.setValue(ajoutMatchViewController.match.resultat, forKey: "resultat")
            match.setValue(ajoutMatchViewController.match.firstName, forKey: "firstName")
            match.setValue(ajoutMatchViewController.match.lastName, forKey: "lastName")
            match.setValue(ajoutMatchViewController.match.wo, forKey: "wo")
            match.setValue(ajoutMatchViewController.match.classement.value, forKey: "classement")
            match.setValue(ajoutMatchViewController.match.bonus, forKey: "bonus")
            match.setValue(ajoutMatchViewController.match.coef, forKey: "coef")
            match.setValue(ajoutMatchViewController.match.score, forKey: "score")
            match.setValue(ajoutMatchViewController.match.tournoi, forKey: "tournoi")
            
            var error: NSError?
            do {
                try managedContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save \(error), \(error?.userInfo)")
            }
            
            // No need to update the table view as we will reload the data
        }
        self.tableView.reloadData()
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
        let result:Int
        if(section == 0){
            result = barCtrl.user.victoires.count
        }else{
            result = barCtrl.user.defaites.count
        }
        return result
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MatchCell", forIndexPath: indexPath)
                
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor =  UIColor.blackColor()
            let tableau: [Match]
            if (indexPath.section == 0){
                tableau = barCtrl.user.victoires
            }else{
                tableau = barCtrl.user.defaites
            }
            let match = tableau[indexPath.row] as Match
            if(match.wo){
                cell.textLabel?.text = match.lastName + " " + match.firstName  + " (wo)"
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.detailTextLabel?.textColor =  UIColor.grayColor()
            }
            else{
                cell.textLabel?.text = match.lastName + " " + match.firstName
            }
            cell.detailTextLabel?.text = match.classement.string
            
            return cell
    }
   /* override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell
        if(section == 0){
            headerCell.textLabel?.text = "Victoires"
        }else{
            headerCell.textLabel?.text = "Défaites"
        }
        return headerCell as UIView
    }*/
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if(section == 0){
            title = "Victoires"
        }
        else if(section == 1){
            title = "Défaites"
        }
        return title
    }

    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            tableView.dequeueReusableCellWithIdentifier("MatchCell", forIndexPath: indexPath)
                
            if(indexPath.section == 0){
                barCtrl.user.victoires.removeAtIndex(indexPath.row)
            }else{
                barCtrl.user.defaites.removeAtIndex(indexPath.row)
            }
            barCtrl.clearCoreData()
            barCtrl.fillCoreData()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the match to the ModifierMatchController.
        if(segue.identifier == "modifierMatch"){
            if let cell = sender as? UITableViewCell {
                if let controller = (segue.destinationViewController as! UINavigationController).topViewController as? ModifierMatchController{
                    let indexPath = self.tableView.indexPathForCell(cell)!
                    controller.id = indexPath.row
                    if(indexPath.section == 0){
                        controller.match = barCtrl.user.victoires[indexPath.row]
                    }else{
                        controller.match = barCtrl.user.defaites[indexPath.row]
                    }
                }
            }
        }
    }

}


