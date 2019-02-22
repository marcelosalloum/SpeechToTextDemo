//
//  SpeechToTextCoordinator.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit
import EZCoreData

class SpeechToTexCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData

    private weak var speechToTextViewController: SpeechToTextViewController?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Model
        let viewModel = SpeechToTextViewModel()
        viewModel.ezCoreData = ezCoreData
//        viewModel.coordinator = self

        // View Controller:
        guard let speechToTextViewController = SpeechToTextViewController.fromStoryboard(.main) else { return }
        speechToTextViewController.viewModel = viewModel
        viewModel.delegate = speechToTextViewController

        // Present View Controller:
        presenter.pushViewController(speechToTextViewController, animated: true)
        setDeallocallable(with: speechToTextViewController)
        self.speechToTextViewController = speechToTextViewController
    }
}
