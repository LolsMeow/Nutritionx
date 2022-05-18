//
//  Nutrition_Item+CoreDataProperties.swift
//  iOS Dev
//
//  Created by Slice Admin on 12/8/21.
//
//

import Foundation
import CoreData


extension Nutrition_Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nutrition_Item> {
        return NSFetchRequest<Nutrition_Item>(entityName: "Nutrition_Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var calories: String?
    @NSManaged public var fat: String?
    @NSManaged public var serving: String?
    @NSManaged public var id: String?

}

extension Nutrition_Item : Identifiable {

}
