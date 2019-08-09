//
//  SpeechTranslation.swift
//  DesignApp
//
//  Created by Marc Phua on 21/7/19.
//  Copyright © 2019 ashish. All rights reserved.
//

import Foundation
import Speech

class SpeechTranslation {
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) //initialise the speech identifier object
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? //set as optional as the data object may be null to prevent crashing
    private var recognitionTask: SFSpeechRecognitionTask? //set as optional to prevent crashing
    private var audioEngine = AVAudioEngine() //initialising the audio engine class
    var lang:String = "en-US"
    var t:String = "text="
    var text:String = ""
    func authenticate() {
        //give user the permission to excess the microphone here
        speechRecognizer?.delegate = self as? SFSpeechRecognizerDelegate //track avaliablity of the speech recognizer
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("user denied access to speech recongition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                
            }
        }
    }
    func startRecording() {
        if (recognitionTask != nil) {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                //code to transcribe the speech to text in real time
                //self.ViewText.text = result?.bestTranscription.formattedString
                self.t += (result?.bestTranscription.formattedString)!
                self.text = (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                //self.startStopButton.isHidden = false
                //self.startStopButton.isEnabled = true
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch{
            print("audio could not start because of an error")
        }
        //ViewText.text = "Say something please! I am listening"
    }
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        let u = "34.66.101.75:50001/get_data"
        var r  = URLRequest(url: URL(string: u)!)
        r.httpMethod = "POST"
        r.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let d = t.data(using:String.Encoding.ascii, allowLossyConversion: false)
        r.httpBody = d
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange avaliable: Bool) {
        if avaliable {
            //startStopButton.isEnabled = true
        } else {
            //startStopButton.isEnabled = false
        }
    }
}
