//
//  NutritionCell.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 12/6/21.
//

import Foundation
import UIKit
import CoreData

class NutritionCell: UITableViewCell {
    
    //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Brand Name and Item Name will be together
    var id: String?
    var cells:[Nutrition_Item]?
    @IBOutlet var name: UILabel?
    @IBOutlet var calories: UILabel?
    @IBOutlet var fat: UILabel?
    @IBOutlet var serving: UILabel?
    @IBOutlet var fav: UIButton!
    
    @IBAction func favoriteClicked(sender: UIButton){
        addFavorite()
    }
    
    //https://stackoverflow.com/questions/15239407/is-there-any-way-we-can-restrict-duplicate-entries-in-core-data
    //https://www.avanderlee.com/swift/constraints-core-data-entities/
    //https://stackoverflow.com/questions/44237743/how-to-avoid-duplicated-records-in-core-data-ios
    func isEntityAttributeExist(id: String, entityName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func addFavorite(){
        print("Add Favorite")
        if isEntityAttributeExist(id: self.id!, entityName: "Nutrition_Item"){
            print("Already Exists")
        }
        else{
            let new_item = Nutrition_Item(context: self.context)
            new_item.name = self.name!.text
            new_item.calories = self.calories!.text
            new_item.fat = self.fat!.text
            new_item.serving = self.serving!.text
            new_item.id = self.id!
            
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fav.setTitle("Added", for: .normal)
        }
        
    }
}
