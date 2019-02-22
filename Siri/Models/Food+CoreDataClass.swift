//
//  Food+CoreDataClass.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 21/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//
//

import Foundation
import CoreData
import EZCoreData

public class Food: NSManagedObject {

}

extension Food {
    public override func populateFromJSON(_ json: [String : Any], context: NSManagedObjectContext) {
        if let foodName = json["food_name"] as? String {
            self.foodName = foodName
        }
        if let servingQty = json["serving_qty"] as? Double {
            self.servingQty = servingQty
        }
        if let servingUnit = json["serving_unit"] as? String {
            self.servingUnit = servingUnit
        }
        if let servingWeightGrams = json["serving_weight_grams"] as? Double {
            self.servingWeightGrams = servingWeightGrams
        }
        if let calories = json["nf_calories"] as? Double {
            self.calories = calories
        }
        if let totalFat = json["nf_total_fat"] as? Double {
            self.totalFat = totalFat
        }
        if let totalCarbohydrate = json["nf_total_carbohydrate"] as? Double {
            self.totalCarbohydrate = totalCarbohydrate
        }
        if let protein = json["nf_protein"] as? Double {
            self.protein = protein
        }
    }
}
