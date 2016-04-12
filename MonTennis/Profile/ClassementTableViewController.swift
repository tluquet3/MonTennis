//
//  ClassementTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 30/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ClassementTableViewController: UITableViewController{

    private var selectedClassement : String!
    
    private let pickerData = ["NC","40","30/5","30/4","30/3","30/2","30/1","30","15/5","15/4","15/3","15/2","15/1","15","5/6","4/6","3/6","2/6","1/6","0","-2/6","-4/6","-15","N°60-100","N°40-60","1ère Serie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedClassement = barCtrl.user.classement.string
        let indexPath = NSIndexPath(forRow: barCtrl.user.classement.value, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveDetails"{
            if let cell = sender as? UITableViewCell {
                selectedClassement = cell.textLabel?.text
                barCtrl.getNSuserDefaults().setInteger(Classement(stringValue: selectedClassement).value, forKey: "classement")
                barCtrl.user.classement = Classement(stringValue: selectedClassement)
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return pickerData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("classementCell", forIndexPath: indexPath)
                
            
            cell.textLabel?.text = pickerData[indexPath.row]
            if(indexPath.row == barCtrl.user.classement.value){
                cell.textLabel?.textColor = UIColor.orangeColor()
                cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            
            return cell
    }
   
}
