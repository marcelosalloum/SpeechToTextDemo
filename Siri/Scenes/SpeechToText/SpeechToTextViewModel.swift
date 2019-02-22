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

    var ezCoreData: EZCoreData!
    var date: Date!
    var foodToAdd = [Food]()

    var speechToTextService = SpeechToTextService()

    weak var delegate: SpeechToTextDelegate?

    var isRecording: Bool {
        return speechToTextService.isRecording
    }

    lazy var localContext: NSManagedObjectContext = {
        self.ezCoreData.privateThreadContext
    }()

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
