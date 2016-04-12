//
//  AjoutMatchViewController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 24/05/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class AjoutMatchViewController:  UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var resultatSwitch: UISegmentedControl!
    @IBOutlet weak var woSwitch: UISwitch!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var classementPicker: UIPickerView!
    @IBOutlet weak var bonusSwitch: UISwitch!
    @IBOutlet weak var btnEnregister: UIBarButtonItem!
    @IBOutlet weak var formatSegment: UISegmentedControl!
    
    
    private let pickerData = ["NC","40","30/5","30/4","30/3","30/2","30/1","30","15/5","15/4","15/3","15/2","15/1","15","5/6","4/6","3/6","2/6","1/6","0","-2/6","-4/6","-15","N°60-100","N°40-60","1ère Serie"]
    var match:Match!
    var selectedClassement = "NC"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classementPicker.dataSource = self
        classementPicker.delegate = self
        nomField.delegate = self
        prenomField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func textFieldAction(sender: AnyObject) {
        if(!nomField.text!.isEmpty && !prenomField.text!.isEmpty){
            btnEnregister.enabled = true
        }else{
            btnEnregister.enabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveMatchDetails" {
            let resultat : Bool
            if(resultatSwitch.selectedSegmentIndex == 0 ){
                resultat = true
            }else{
                resultat = false
            }
            let coefValue : Double
            if(formatSegment.selectedSegmentIndex == 0){
                coefValue = 1.0
            }else{
                coefValue = 0.6
            }
            self.match = Match(resultat: resultat , firstName: prenomField.text!, lastName: nomField.text!, classement: Classement(stringValue: selectedClassement), bonus: bonusSwitch.on, coef: coefValue, wo: woSwitch.on)
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.orangeColor()])
        return myTitle
    }
    // Put the selected data in the string classement
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedClassement = pickerData[row]
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === nomField && prenomField.text!.isEmpty){
            nomField.resignFirstResponder()
            prenomField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }

}
