//
//  Coordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData
import CoreData

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    var ezCoreData: EZCoreData
    let rootViewController: UINavigationController

    init(window: UIWindow) {
        // Init Values
        self.window = window
        rootViewController = UINavigationController()
        ezCoreData = EZCoreData()
        ezCoreData.setupPersistence(Constant.modelName) // Initialize Core Data

        super.init()
        // Init Core Data

        // SetUp Welcome Coordinator
        setupSpeechToTextCoordinator()
//        setupHistoryCollectionCoordinator()
    }

    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    fileprivate func setupSpeechToTextCoordinator() {
        let coordinator = SpeechToTexCoordinator(presenter: rootViewController, ezCoreData: ezCoreData)
        startCoordinator(coordinator)
    }

    fileprivate func setupHistoryCollectionCoordinator() {
        let coordinator = HistoryCollectionViewCoordinator(presenter: rootViewController, ezCoreData: ezCoreData)
        startCoordinator(coordinator)
    }
}
