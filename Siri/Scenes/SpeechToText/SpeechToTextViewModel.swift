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

class SpeechToTextViewModel: NSObject {

    var ezCoreData: EZCoreData!

    var speechToTextService = SpeechToTextService()

    weak var delegate: SpeechToTextDelegate?

    var isRecording: Bool {
        return speechToTextService.isRecording
    }

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
            self.ezCoreData.privateThreadContext.saveContextToStore()
            switch result {
            case .success(let value):
                print(value!)
            case .failure(let error):
                print(error)
            }
        }
    }
}
