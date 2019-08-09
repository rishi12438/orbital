//
//  SpeechViewController.swift
//  DesignApp
//
//  Created by Marc Phua on 23/7/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit
import Speech
class SpeechViewController: UIViewController {

    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var ViewText: UITextView!
    
    @IBOutlet weak var SiriActivation: UIButton!
    var s:String = "text="
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) //initialise the speech identifier object
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? //set as optional as the data object may be null to prevent crashing
    private var recognitionTask: SFSpeechRecognitionTask? //set as optional to prevent crashing
    private var audioEngine = AVAudioEngine() //initialising the audio engine class
    var lang: String = "en-US"
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewText.isHidden = true
        startStopButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SiriActionPress(_ sender: Any) {
        SiriActivation.isEnabled = false
        ViewText.isHidden = false
        ViewText.text = ""
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
                
                if (isButtonEnabled) {
                    self.startStopButton.isHidden = false
                }
                
                self.startStopButton.isEnabled = isButtonEnabled
            }
            
        }
    }
    

    @IBAction func startStopPress(_ sender: Any) {
        if (audioEngine.isRunning) {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            SiriActivation.isEnabled = true
            startStopButton.isEnabled = false
            startStopButton.isHidden = true
            ViewText.isHidden = true
            startStopButton.setTitle("Start Recording", for: .normal)
            s += self.ViewText.text
            print(s)
            post()
        } else {
            ViewText.text = ""
            s = "text="
            startRecording()
            startStopButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func P_Send(_ sender: Any) {
        post()
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
                self.ViewText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.startStopButton.isHidden = false
                self.startStopButton.isEnabled = true
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
        ViewText.text = "Say something please! I am listening"
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange avaliable: Bool) {
        if avaliable {
            startStopButton.isEnabled = true
        } else {
            startStopButton.isEnabled = false
        }
    }
    func post() {
        let u = "http://34.66.101.75:5001/get_data"
        var r  = URLRequest(url: URL(string: u)!)
        r.httpMethod = "POST"
        r.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let d = s.data(using:String.Encoding.ascii, allowLossyConversion: false)
        r.httpBody = d
        let task = URLSession.shared.dataTask(with: r) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
