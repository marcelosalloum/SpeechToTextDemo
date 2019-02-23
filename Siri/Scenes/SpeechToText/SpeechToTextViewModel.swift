//
//  ViewController.swift
//  Siri
//
//  Created by Sahand Edrisian on 7/14/16.
//  Copyright © 2016 Sahand Edrisian. All rights reserved.
//

import UIKit
import Speech
import EZCoreData
import CoreData

class SpeechToTextViewModel: NSObject {

    // MARK: - Injected Dependencies
    var ezCoreData: EZCoreData!
    var date: Date!
    weak var delegate: SpeechToTextDelegate?

    // MARK: - Local Instances
    private var foodToAdd = [Food]()
    private var speechToTextService = SpeechToTextService()

    private lazy var localContext: NSManagedObjectContext = {
        self.ezCoreData.newPrivateContext()
    }()

    var isRecording: Bool {
        return speechToTextService.isRecording
    }
}

// MARK: - ViewController
extension SpeechToTextViewModel {
    func setupSpeechRecognizer() {
        speechToTextService.delegate = self
        speechToTextService.requestSpeechAuthorization()
    }

    func stopRecording() {
        speechToTextService.stopRecording()
    }

    func startRecording() {
        speechToTextService.startRecording()
    }
}

// MARK: - User Interaction
extension SpeechToTextViewModel {
    func closeButtonPressed() {
        localContext.saveContextToStore()
    }
}

// MARK: - Speech Recognizer
extension SpeechToTextViewModel: SpeechToTextDelegate {
    func didStartTranscriptingSpeech() {
        delegate?.didStartTranscriptingSpeech()
    }

    func failedToStartTranscriptingSpeech(_ error: Error) {
        delegate?.failedToStartTranscriptingSpeech(error)
    }

    func speechRecognizerAuthorized(_ wasAuthorized: Bool) {
        OperationQueue.main.addOperation {
            self.delegate?.speechRecognizerAuthorized(wasAuthorized)
        }
    }

    func transcriptedString(_ transcriptedText: String?) {
        delegate?.transcriptedString(transcriptedText)
    }

    func didFinishTranscriptingSpeech() {
        delegate?.didFinishTranscriptingSpeech()
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        delegate?.speechRecognizer(speechRecognizer, availabilityDidChange: available)
    }
}

// MARK: - API Service
extension SpeechToTextViewModel {

    func verifyFoodCalories(_ text: String) {

        APIService.verifyFoodCalories(text, context: ezCoreData.privateThreadContext) { result in
            switch result {
            case .success(let value):
                guard let foodList = value else { return }
                for food in foodList {
                    food.date = self.date
                }
                self.foodToAdd.append(contentsOf: foodList)
            case .failure(let error):
                print(error)
            }
        }
    }
}
