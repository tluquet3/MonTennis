//
//  ChangeSexeController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 30/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ChangeSexeController: UITableViewController {
    
    
    @IBOutlet weak var hommeCell: UITableViewCell!
    @IBOutlet weak var femmeCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(barCtrl.user.sexe){
            hommeCell.accessoryType = .Checkmark
            femmeCell.accessoryType = .None
        }else{
            hommeCell.accessoryType = .None
            femmeCell.accessoryType = .Checkmark
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let userData = barCtrl.getNSuserDefaults()
        if(hommeCell.selected){
            barCtrl.user.sexe = true
            userData.setBool(true, forKey: "sex")
        }else{
            barCtrl.user.sexe = false
            userData.setBool(false, forKey: "sex")
        }
    }


}
