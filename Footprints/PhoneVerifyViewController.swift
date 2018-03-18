//
//  PhoneVerifyViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 3/18/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabase

class PhoneVerifyViewController: UIViewController {

    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func phoneSubmit(_ sender: Any) {
        guard let phone = phoneTF.text, phone != "" else {
            AlertController.showAlert(self, title: "Phone error", message: "Phone number not entered")
            return
        }
        let phoneMod = phone.replacingOccurrences(of: "-", with: "")
        let phoneUser = self.phoneUser(phone: phoneMod)
       
        guard phoneUser == nil else {
            AlertController.showAlert(self, title: "Phone error", message: "Phone number is already being used. Please contact us if this is an error.")
            return
        }
        let userUID = Auth.auth().currentUser!.uid
        self.phoneSave(phone: phoneMod, userID: userUID)
        self.performSegue(withIdentifier: "phoneVerifiedSegue", sender: nil)
    }
    
        func phoneUser(phone: String) -> String? {
            print("in phone check")
            let dbPhones = DatabaseAPI.shared.phonesReference
            var usedBy: String?
            dbPhones.child(String(phone)).observe(DataEventType.value, with: {(snapshot) in
                usedBy = snapshot.value as? String
            })
            return usedBy
        }
    
        func phoneSave(phone: String, userID: String) {
            let dbPhones = DatabaseAPI.shared.phonesReference
            dbPhones.child(String(phone)).setValue(userID)
        }
    

}
