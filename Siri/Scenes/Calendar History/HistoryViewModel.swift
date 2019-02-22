//
//  HistoryDataSource.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit

class HistoryViewModel: NSObject {
    let days = [
        Day(date: Date.yesterday, name: "Yesterday"),
        Day(date: Date(), name: "Today"),
        Day(date: Date.tomorrow, name: "Tomorrow")
    ]
}

struct Day {
    let date: Date
    let name: String
}
