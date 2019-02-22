//
//  ViewController.swift
//  Siri
//
//  Created by Sahand Edrisian on 7/14/16.
//  Copyright © 2016 Sahand Edrisian. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class SpeechToTextViewController: CoordinatedViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!

    var viewModel: SpeechToTextViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // microphoneButton
        microphoneButton.isEnabled = false

        // viewModel
        viewModel.setupSpeechRecognizer()
    }

    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if viewModel.isRecording {
            viewModel.stopRecording()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
            viewModel.verifyFoodCalories(textView.text)
        } else {
//            let utterance = AVSpeechUtterance(string: "Ok, o que você comeu?")
//            utterance.voice = AVSpeechSynthesisVoice(language: Constant.languageRegion)
//            let synthesizer = AVSpeechSynthesizer()
//            synthesizer.speak(utterance)
            viewModel.startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
}

// MARK: - SpeechToTextDelegate
extension SpeechToTextViewController: SpeechToTextDelegate {
    func speechRecognizerAuthorized(_ wasAuthorized: Bool) {
        microphoneButton.isEnabled = wasAuthorized
    }

    func didStartTranscriptingSpeech() {
        textView.text = "Say something, I'm listening!"
    }

    func failedToStartTranscriptingSpeech(_ error: Error) {
        textView.text = error.localizedDescription
    }

    func transcriptedString(_ transcriptedText: String?) {
        textView.text = transcriptedText
    }

    func didFinishTranscriptingSpeech() {
        microphoneButton.isEnabled = true
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        microphoneButton.isEnabled = available
    }
}
