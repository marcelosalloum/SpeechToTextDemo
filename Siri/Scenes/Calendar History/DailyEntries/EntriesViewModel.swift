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
    // MARK: - Injected Dependencies
    var ezCoreData: EZCoreData!
    var date: Date!

    // MARK: - DataSource
    var foodList = [Food]()

    func updateFoodList() {
        let pred = NSPredicate(format: "date >= %@ AND date <= %@", date.firstHour as NSDate, date.lastHour as NSDate)
        do {
            foodList = try Food.readAll(predicate: pred, context: ezCoreData.mainThreadContext)
            print(foodList)
        } catch let error {
            print(error)
        }
    }
}
