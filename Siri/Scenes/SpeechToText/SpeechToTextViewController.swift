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

    // MARK: - Injected Dependencies
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    var viewModel: SpeechToTextViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // microphoneButton
        microphoneButton.isEnabled = false

        // viewModel
        viewModel.setupSpeechRecognizer()
    }
}

// MARK: - User Interactions
extension SpeechToTextViewController {

    @IBAction func microphoneTapped(_ sender: UIButton) {
        sender.animateTouchDown {
            if self.viewModel.isRecording {
                self.viewModel.stopRecording()
                self.microphoneButton.isEnabled = false
                self.microphoneButton.setImage(UIImage(named: "icn_mic_on"), for: .normal)
                self.viewModel.verifyFoodCalories(self.textView.text)
            } else {
                self.viewModel.startRecording()
                self.microphoneButton.setImage(UIImage(named: "icn_mic_off"), for: .normal)
            }
        }
    }

    @IBAction func closeButtonClicked(_ sender: UIButton) {
        viewModel.closeButtonPressed()
        sender.animateTouchDown {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - SpeechToTextDelegate
extension SpeechToTextViewController: SpeechToTextDelegate {
    func speechRecognizerAuthorized(_ wasAuthorized: Bool) {
        microphoneButton.isEnabled = wasAuthorized
    }

    func didStartTranscriptingSpeech() {
        textView.text = "Tell me about your meal..."
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
