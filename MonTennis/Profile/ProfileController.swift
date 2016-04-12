//
//  ProfileController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 30/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var completeName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var classement: UILabel!
    @IBOutlet weak var club: UILabel!
    @IBOutlet weak var sexe: UILabel!
    
    //private var barCtrl : TabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.barCtrl = self.tabBarController as! TabBarController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        completeName.text = barCtrl.user.prenom + " " + barCtrl.user.nom
        lastName.text =  barCtrl.user.nom
        firstName.text = barCtrl.user.prenom
        classement.text = barCtrl.user.classement.string
        club.text = barCtrl.user.club
        
        if(barCtrl.user.sexe){
            sexe.text = "Homme"
        }else{
            sexe.text = "Femme"
        }
    }
    
    @IBAction func saveProfileChanges(segue:UIStoryboardSegue){
        self.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
