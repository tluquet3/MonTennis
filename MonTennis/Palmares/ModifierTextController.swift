//
//  ModifierTextController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 03/07/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class ModifierTextController: UITableViewController {

    internal var textValue: String!
    internal var textType: String!
    @IBOutlet weak var textField: UITextField!
    internal var match: Match!
    internal var id: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = textValue
        self.navigationItem.title = textType
        
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "saveMatchChanges"){
            switch textType {
            case "Nom":
                if(match.resultat){
                    barCtrl.user.victoires[id].lastName = textField.text!
                }else{
                    barCtrl.user.defaites[id].lastName = textField.text!
                }
            case "Prénom":
                if(match.resultat){
                    barCtrl.user.victoires[id].firstName = textField.text!
                }else{
                    barCtrl.user.defaites[id].firstName = textField.text!
                }
            default:
                textType = "error"
            }
        barCtrl.clearCoreData()
        barCtrl.fillCoreData()
        }
    }
    

}
