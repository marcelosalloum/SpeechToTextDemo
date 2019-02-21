//
//  Food+CoreDataProperties.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 21/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var servingQty: Float
    @NSManaged public var servingWeightGrams: Float
    @NSManaged public var foodName: String?
    @NSManaged public var servingUnit: String?
    @NSManaged public var calories: Float
    @NSManaged public var totalFat: Float
    @NSManaged public var totalCarbohydrate: Float
    @NSManaged public var protein: Float

}
