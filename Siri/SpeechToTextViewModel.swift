//
//  ViewController.swift
//  Siri
//
//  Created by Sahand Edrisian on 7/14/16.
//  Copyright © 2016 Sahand Edrisian. All rights reserved.
//

import UIKit
import Speech


struct Constant {
    static let languageRegion: String = "pt-BR"
}

protocol SpeechToTextDelegate: class {
    func didStartTranscriptingSpeech()
    func failedToStartTranscriptingSpeech(_ error: Error)
    func speechRecognizerAuthorized(_ wasAuthorized: Bool)
    func transcriptedString(_ transcriptedText: String?)
    func didFinishTranscriptingSpeech()
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer,
                          availabilityDidChange available: Bool)
}

class SpeechToTextViewModel: NSObject {

    fileprivate let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Constant.languageRegion))!
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?

    weak var delegate: SpeechToTextDelegate?

    var isRecording: Bool {
        return audioEngine.isRunning
    }

    func setupSpeechRecognizer() {
        speechRecognizer.delegate = self
        requestSpeechAuthorization()
    }
}

// MARK: - Speech Recognizer
extension SpeechToTextViewModel {

    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var wasAuthorized = false

            switch authStatus {
            case .authorized:
                wasAuthorized = true

            case .denied:
                wasAuthorized = false
                print("User denied access to speech recognition")

            case .restricted:
                wasAuthorized = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                wasAuthorized = false
                print("Speech recognition not yet authorized")
            }

            OperationQueue.main.addOperation() {
                self.delegate?.speechRecognizerAuthorized(wasAuthorized)
            }
        }
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }

    func startRecording() {

        // Resets recognitionTask
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Setup audioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            print(error.localizedDescription)
            print("audioSession properties weren't set because of an error.")
        }

        // Unraps inputNode
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }

        // Setup recognitionRequest
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true

        // !!! This is the imprtant part, where the speech will be transcrpted to text:
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: handleRecognitionResult)

        // Configures the node and installs the tap
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        // Finally starts the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            delegate?.didStartTranscriptingSpeech()
        } catch let error {
            print("audioEngine couldn't start because of an error.")
            delegate?.failedToStartTranscriptingSpeech(error)
        }
    }

    func handleRecognitionResult(_ result: SFSpeechRecognitionResult?, _ error: Error?) {
        var isFinal = false

        // Called after a transcription is updated
        if result != nil {
            delegate?.transcriptedString(result?.bestTranscription.formattedString) //9
            isFinal = (result?.isFinal)!
        }

        // Called after the service was stopped
        if error != nil || isFinal {
            audioEngine.stop()
            audioEngine.inputNode?.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil

            delegate?.didFinishTranscriptingSpeech()
        }
    }
}

extension SpeechToTextViewModel: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        delegate?.speechRecognizer(speechRecognizer, availabilityDidChange: available)
    }
}

