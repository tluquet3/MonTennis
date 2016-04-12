//
//  PrenomTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 30/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class PrenomTableViewController: UITableViewController {

    @IBOutlet weak var prenomField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prenomField.text = barCtrl.user.prenom
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveDetails"{
            barCtrl.getNSuserDefaults().setObject(prenomField.text, forKey: "firstName")
            barCtrl.user.prenom = prenomField.text!
        }
    }
}
