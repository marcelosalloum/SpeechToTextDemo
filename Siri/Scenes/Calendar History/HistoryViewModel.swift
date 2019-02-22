//
//  HistoryDataSource.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit
import EZCoreData

class HistoryViewModel: NSObject {

    var ezCoreData: EZCoreData!

    weak var coordinator: HistoryCoordinatorDelegate?

    let days = [
        Day(date: Date.yesterday, name: "Yesterday"),
        Day(date: Date(), name: "Today"),
        Day(date: Date.tomorrow, name: "Tomorrow")
    ]

    func userDidSelectAddButton(_ day: Day) {
        coordinator?.userDidSelectAddButton(day.date)
    }

    lazy var childViewModels: [EntriesViewModel] = {
        var children = [EntriesViewModel]()

        for day in days {
            let viewModel = EntriesViewModel()
            viewModel.ezCoreData = ezCoreData
            viewModel.date = day.date
            children.append(viewModel)
        }

        return children
    }()
}

struct Day {
    let date: Date
    let name: String
}
