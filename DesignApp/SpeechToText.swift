//
//  SpeechToText.swift
//  DesignApp
//
//  Created by Marc Phua on 22/7/19.
//  Copyright © 2019 ashish. All rights reserved.
//

import UIKit

class SpeechToText: UIViewController {
    var s = SpeechTranslation();
    @IBOutlet weak var Trans: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        s.authenticate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StartPress(_ sender: Any) {
        s.startRecording()
        Trans.text = s.text
    }
    
    @IBAction func StopPress(_ sender: Any) {
       s.stopRecording()
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
