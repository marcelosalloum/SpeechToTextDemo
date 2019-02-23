//
//  SpeechToTextCoordinator.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit
import EZCoreData

class HistoryCollectionViewCoordinator: Coordinator {
    // MARK: - ViewController
    private weak var historyCollectionViewController: HistoryCollectionViewController?

    // MARK: - Injected dependencies
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData
    private var speechToTextService: SpeechToTextService

    init(presenter: UINavigationController, ezCoreData: EZCoreData, speechToTextService: SpeechToTextService) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
        self.speechToTextService = speechToTextService
    }

    // MARK: - Default Start
    override func start() {
        // View Model
        let viewModel = HistoryViewModel()
        viewModel.ezCoreData = ezCoreData
        viewModel.coordinator = self

        // View Controller:
        guard let historyCollectionVC = HistoryCollectionViewController.fromStoryboard(.calendarHistory) else { return }
        historyCollectionVC.viewModel = viewModel
        // viewModel.delegate = historyCollectionVC

        // Present View Controller:
        presenter.pushViewController(historyCollectionVC, animated: true)
        setDeallocallable(with: historyCollectionVC)
        self.historyCollectionViewController = historyCollectionVC
    }
}

// MARK: - HistoryCoordinatorDelegate
protocol HistoryCoordinatorDelegate: class {
    func userDidSelectAddButton(_ date: Date)
}

extension HistoryCollectionViewCoordinator: HistoryCoordinatorDelegate {
    func userDidSelectAddButton(_ date: Date) {
        let coordinator = SpeechToTexCoordinator(presenter: presenter, ezCoreData: ezCoreData, date: date)
        startCoordinator(coordinator)
    }
}
