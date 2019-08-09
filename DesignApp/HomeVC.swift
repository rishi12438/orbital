//
//  HomeVC.swift
//  DesignApp
//
//  Created by Marc Phua on 08/07/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func function1() {
        // add your code here
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SpeechToText") as! SpeechViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func function2() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PhotoView") as! PhotoView
        self.present(nextViewController, animated:true, completion:nil)
    }
    func function3() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MedicineView") as! MedicineViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        if (indexPath.row == 0) {
              cell.lblTitle.text = "Doctor Call"
              cell.imgView.image = UIImage(named: "callicon")
        } else if (indexPath.row == 1) {
            cell.lblTitle.text = "Medicine Identification"
            cell.imgView.image = UIImage(named: "Medication")
        } else if(indexPath.row == 2) {
            cell.lblTitle.text = "Prescription"
            cell.imgView.image = UIImage(named:"Fake-medicine")
        } else {
            cell.lblTitle.text = "Feedback"
            cell.imgView.image = UIImage(named: "Medication")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let alert = UIAlertController(title: "DesignApp", message: "Function \(indexPath.row+1)", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        */
        // call your function by index
        
        if indexPath.row == 0 {
            function1()
        }
        if indexPath.row == 1 {
            function2()
        }
        if indexPath.row == 2 {
            function3()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/2), height: (collectionView.frame.size.width/2))
    }
    
}
