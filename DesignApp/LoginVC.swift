//
//  LoginVC.swift
//  DesignApp
//
//  Created by Marc Phua on 08/07/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit
import Foundation
class LoginVC: UIViewController {
    struct GlobalVariable {
        static var email = String()
    }
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var s:String = ""
    var res:String = ""
    var dummy:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }

    // MARK:- Class Methods
    
    func initialization() {
        self.navigationController?.isNavigationBarHidden = true
        
        viewBack.layer.cornerRadius = 10.0
        viewBack.clipsToBounds = true
        viewBack.layer.borderColor = UIColor.gray.cgColor
        viewBack.layer.borderWidth = 0.5
        
        txtUsername.addLeftView(imageName: "man-user")
        txtPassword.addLeftView(imageName: "lock")
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
        s = ""
        s += "username="
        s += (txtUsername.text)!
        s += "&password="
        s += (txtPassword.text)!
        post()
    }
    
    func post() {
        let u = "http://34.66.101.75:5001/login"
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
            let nameArr = responseString!.components(separatedBy: " ")
            var i = 0
            for word in nameArr {
                if (i == 0) {
                    self.res = word
                } else {
                    self.dummy = word
                }
                i += 1
            }
        }
        task.resume()
        if (res == "True") {
            GlobalVariable.email = dummy
            self.performSegue(withIdentifier: "segueToHome", sender: nil)
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid Username/Password", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UITextField {
    func addLeftView(imageName : String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height/2))
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        self.leftView = imageView
        self.leftViewMode = .always
    }
}
