//
//  SpeechToTextCoordinator.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit
import EZCoreData

protocol HistoryCoordinatorDelegate: class {
    func userDidSelectAddButton(_ date: Date)
}

class HistoryCollectionViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData
    private var speechToTextService: SpeechToTextService

    private weak var historyCollectionViewController: HistoryCollectionViewController?

    init(presenter: UINavigationController, ezCoreData: EZCoreData, speechToTextService: SpeechToTextService) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
        self.speechToTextService = speechToTextService
    }

    override func start() {
        // View Model
        let viewModel = HistoryViewModel()
        viewModel.coordinator = self
//        viewModel.ezCoreData = ezCoreData

        // View Controller:
        guard let historyCollectionVC = HistoryCollectionViewController.fromStoryboard(.calendarHistory) else { return }
        historyCollectionVC.viewModel = viewModel
//        viewModel.delegate = historyCollectionViewController

        // Present View Controller:
        presenter.pushViewController(historyCollectionVC, animated: true)
        setDeallocallable(with: historyCollectionVC)
        self.historyCollectionViewController = historyCollectionVC
    }
}

extension HistoryCollectionViewCoordinator: HistoryCoordinatorDelegate {
    func userDidSelectAddButton(_ date: Date) {
        let coordinator = SpeechToTexCoordinator(presenter: presenter, ezCoreData: ezCoreData, date: date)
        startCoordinator(coordinator)
    }
}
