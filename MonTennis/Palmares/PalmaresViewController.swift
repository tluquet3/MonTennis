//
//  FirstViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 21/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit
//import CoreData


class PalmaresViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var PalmaresVictoireTableView: UITableView!
    @IBOutlet weak var PalmaresDefaitesTableView: UITableView!
    var user = Utilisateur(firstName: "Thomas", lastName: "Luquet", classement: Classement(value: 10), sex: true)
    
    
    @IBAction func cancelToPalmaresViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveMatchDetails(segue:UIStoryboardSegue) {
        if let ajoutMatchViewController = segue.sourceViewController as? AjoutMatchViewController {
            
            //add the new player to the players array
            user.ajoutMatch(ajoutMatchViewController.match)
            
            //update the tableView
            let indexPath: NSIndexPath
            if(ajoutMatchViewController.match.resultat){
                indexPath = NSIndexPath(forRow: user.getNbVictoires()-1, inSection: 0)
                PalmaresVictoireTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }else{
                indexPath = NSIndexPath(forRow: user.getNbDefaites()-1, inSection: 0)
                PalmaresDefaitesTableView.insertRowsAtIndexPaths([indexPath],withRowAnimation: .Automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PalmaresDefaitesTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "CellD")
        PalmaresVictoireTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "CellV")
        
        user.ajoutMatch(Match(resultat: true, firstName: "Michel", lastName: "Delpech", classement: Classement(value:12), bonus: false, coef: 1.0, wo: false))
        user.ajoutMatch(Match(resultat: true, firstName: "Damien", lastName: "Billerit", classement: Classement(value:12), bonus: false, coef: 1.0, wo: false))
        user.ajoutMatch(Match(resultat: true, firstName: "Remi", lastName: "Peck", classement: Classement(value:12), bonus: false, coef: 1.0, wo: false))
        
        var cellHeight  = CGFloat(self.PalmaresVictoireTableView.rowHeight)
        var totalCity   = CGFloat(3)
        var totalHeight = cellHeight * totalCity
        self.PalmaresVictoireTableView.frame.size.height = totalHeight
    }
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            let result:Int
            if(tableView == self.PalmaresVictoireTableView){
                result = user.victoires.count
            }else{
                result = user.defaites.count
            }
            return result
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            let cell : UITableViewCell
            if(tableView == self.PalmaresVictoireTableView){
                cell =
            tableView.dequeueReusableCellWithIdentifier("CellV")
                as! UITableViewCell
                cell.textLabel!.text = user.victoires[indexPath.row].lastName + user.victoires[indexPath.row].firstName + "          " + user.victoires[indexPath.row].classement.string
            }else{
                    cell =
                tableView.dequeueReusableCellWithIdentifier("CellD")
                    as! UITableViewCell
                cell.textLabel!.text = user.defaites[indexPath.row].lastName + user.defaites[indexPath.row].firstName + "          " + user.defaites[indexPath.row].classement.string
            }
            return cell
    }


}

