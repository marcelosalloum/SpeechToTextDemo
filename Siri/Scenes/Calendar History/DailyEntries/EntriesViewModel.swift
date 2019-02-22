//
//  EntriesViewModel.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import Foundation
import EZCoreData

class EntriesViewModel: NSObject {
    var ezCoreData: EZCoreData!
    var foodList = [Food]()
    var date: Date!

    func updateFoodList() {
        let predicate = NSPredicate(format: "date = \(date.toString(dateFormat: "yyyy-MM-dd"))")
        do {
            foodList = try Food.readAll(context: ezCoreData.mainThreadContext)
            print(foodList)
        } catch let error {
            print(error)
        }
    }
}
