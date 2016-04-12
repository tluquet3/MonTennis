//
//  TabBarController.swift
//  MonTennis
//
//  Created by Thomas Luquet on 02/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit
import CoreData

var barCtrl : TabBarController!

class TabBarController: UITabBarController {
    
    
    internal var user : Utilisateur!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change the appearance of the tab bar
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColorFromRGB(0x007AFF)], forState:.Selected)
        //Change the color of the tab bar icons to white
        for item in self.tabBar.items as [UITabBarItem]! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        barCtrl = self
    }
    override func viewWillAppear(animated: Bool) {
        // Load Profile from NSUserDefault
        let userData = NSUserDefaults.standardUserDefaults()
        
        if(userData.stringForKey("firstName") == nil){
            userData.setObject(" ", forKey: "firstName")
            userData.setObject(" ", forKey: "lastName")
            userData.setBool(true, forKey: "sex")
            userData.setInteger(Classement(stringValue: "NC").value, forKey: "classement")
            userData.setObject(" ", forKey: "club")
            self.selectedIndex = 2
        }
        user = Utilisateur(firstName: userData.stringForKey("firstName")!, lastName: userData.stringForKey("lastName")!, classement: Classement(value: userData.integerForKey("classement")), sex: userData.boolForKey("sex"),club: userData.stringForKey("club")!)
        
        // Load palmares data from CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Match")
        do{
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                user.viderPalmares()
                var match: Match
                for matchF in results{
                    match = Match(resultat: matchF.valueForKey("resultat") as! Bool, firstName: matchF.valueForKey("firstName") as! String, lastName: matchF.valueForKey("lastName") as! String, classement: Classement(value: matchF.valueForKey("classement") as! Int), bonus: matchF.valueForKey("bonus") as! Bool, coef: matchF.valueForKey("coef") as! Double, wo: matchF.valueForKey("wo") as! Bool)
                    user.ajoutMatch(match)
                }
            }

        }catch {
            print("Could not fetch \(error)")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Core Data 
    internal func fillCoreData(){
        //Update the coreData
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Match",
            inManagedObjectContext:
            managedContext)
        for matchU in user.victoires{
            let match = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            match.setValue(matchU.resultat, forKey: "resultat")
            match.setValue(matchU.firstName, forKey: "firstName")
            match.setValue(matchU.lastName, forKey: "lastName")
            match.setValue(matchU.wo, forKey: "wo")
            match.setValue(matchU.classement.value, forKey: "classement")
            match.setValue(matchU.bonus, forKey: "bonus")
            match.setValue(matchU.coef, forKey: "coef")
            match.setValue(matchU.score, forKey: "score")
            match.setValue(matchU.tournoi, forKey: "tournoi")
        }
        for matchU in user.defaites{
            let match = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            match.setValue(matchU.resultat, forKey: "resultat")
            match.setValue(matchU.firstName, forKey: "firstName")
            match.setValue(matchU.lastName, forKey: "lastName")
            match.setValue(matchU.wo, forKey: "wo")
            match.setValue(matchU.classement.value, forKey: "classement")
            match.setValue(matchU.bonus, forKey: "bonus")
            match.setValue(matchU.coef, forKey: "coef")
            match.setValue(matchU.score, forKey: "score")
            match.setValue(matchU.tournoi, forKey: "tournoi")
        }
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    internal func clearCoreData(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        do{
            let fetchRequest = NSFetchRequest(entityName:"Match")
            var fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                for matchF in results{
                    managedContext.deleteObject(matchF as NSManagedObject)
                }
                fetchedResults?.removeAll(keepCapacity: false)
                do {
                    try managedContext.save()
                } catch _ {
                }
            }
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    internal func getNSuserDefaults()->NSUserDefaults{
         return NSUserDefaults.standardUserDefaults()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    }*/
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func actionSheetForFirstLogin() {
        let actionSheet: UIAlertController = UIAlertController(title: "the  title", message: "the message", preferredStyle: .ActionSheet)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: action.title, message: "You chose an action", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        
        let action1: UIAlertAction = UIAlertAction(title: "action title 1", style: .Default, handler:callActionHandler)
        
        let action2: UIAlertAction = UIAlertAction(title: "action title 2", style: .Default, handler:callActionHandler)
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        
        presentViewController(actionSheet, animated: true, completion:nil)
    }
}
extension UIImage {
        func imageWithColor(tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            
            let context = UIGraphicsGetCurrentContext()! as CGContextRef
            CGContextTranslateCTM(context, 0, self.size.height)
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextSetBlendMode(context, CGBlendMode.Normal)
            
            let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
            CGContextClipToMask(context, rect, self.CGImage)
            tintColor.setFill()
            CGContextFillRect(context, rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
            
            return newImage
        }
}



