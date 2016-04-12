//
//  ClubTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 06/07/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ClubTableViewController: UITableViewController {

    @IBOutlet weak var clubField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubField.text = barCtrl.user.club
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveDetails"{
            barCtrl.getNSuserDefaults().setObject(clubField.text, forKey: "club")
            barCtrl.user.club = clubField.text!
        }
    }
}
