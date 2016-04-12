//
//  NomTableViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 30/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class NomTableViewController: UITableViewController {
    
    @IBOutlet weak var nomField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomField.text = barCtrl.user.nom
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveDetails"{
            barCtrl.getNSuserDefaults().setObject(nomField.text, forKey: "lastName")
            barCtrl.user.nom = nomField.text!
        }
    }

}