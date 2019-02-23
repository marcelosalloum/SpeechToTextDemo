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

    // MARK: - Injected Dependencies
    var ezCoreData: EZCoreData!

    weak var coordinator: HistoryCoordinatorDelegate?

    // MARK: - Data source
    let days = [
        Day(date: Date.yesterday, name: "Yesterday"),
        Day(date: Date(), name: "Today"),
        Day(date: Date.tomorrow, name: "Tomorrow")
    ]

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

// MARK: - ViewController
extension HistoryViewModel {
    func userDidSelectAddButton(_ day: Day) {
        coordinator?.userDidSelectAddButton(day.date)
    }
}

struct Day {
    let date: Date
    let name: String
}
