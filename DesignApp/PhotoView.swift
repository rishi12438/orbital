//
//  PhotoView.swift
//  DesignApp
//
//  Created by Marc Phua on 23/7/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var myImg: UIImageView!
    var s:String = ""
    let synth = AVSpeechSynthesizer()
    @IBOutlet weak var viewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImg.contentMode = .scaleToFill
            myImg.image = pickedImage
            post(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func post(image: UIImage) {
        
        let filename = "avatar.png"
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        /*
        let fieldName = "reqtype"
        let fieldValue = "fileupload"
        let fieldName2 = "userhash"
        let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"
        */
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "http://34.66.101.75:5001/image_reco")!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        /*
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)
        */
        /*
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        */
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("\(responseString)")
                self.s = responseString
            }
        }).resume()
    }
    
    @IBAction func viewResult(_ sender: Any) {
        textView.text = s
        var myUtterance:AVSpeechUtterance
        if (textView.text != "") {
            myUtterance = AVSpeechUtterance(string: s)
        } else {
            myUtterance = AVSpeechUtterance(string: "Loading! Please wait")
        }
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
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
