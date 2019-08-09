//
//  MedicineViewController.swift
//  DesignApp
//
//  Created by Marc Phua on 28/7/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit

struct info {
    var name:String
    var amt:String
    var freq:String
}

class MedicineViewController: UIViewController {
    
    var s:String = "email="
    var types:[info] = []
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func post(_ sender: Any) {
        s = "email="
        s += LoginVC.GlobalVariable.email
        let u = "http://34.66.101.75:5001/get_medicine_list"
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
            let med = responseString?.components(separatedBy:",")
            for m in med! {
                var i:info = info(name: "", amt: "", freq: "")
                let v = m.components(separatedBy: ";")
                i.name = v[0]
                i.amt = v[1]
                i.freq = v[2]
                self.types.append(i)
            }
        }
        task.resume()
    }
    
    
    @IBAction func ViewRes(_ sender: Any) {
        textView.text = ""
        if (!types.isEmpty) {
          for i in types {
            textView.text += "Name: " + i.name + "\n"
            textView.text += "Dosage: " + i.amt + "\n"
            textView.text += "Frequency: " + i.freq + "\n"
            textView.text += "\n"
            textView.text += "\n"
            
          }
        } else {
           textView.text = "Loading...Please Wait"
        }
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
