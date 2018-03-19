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
    var usedBy: String?
    
    @IBAction func phoneSubmit(_ sender: Any) {
        guard let phone = phoneTF.text, phone != "" else {
            AlertController.showAlert(self, title: "Phone error", message: "Phone number not entered")
            return
        }
        let phoneMod = phone.replacingOccurrences(of: "-", with: "")
        self.phoneUser(phone: phoneMod)
        self.phoneCheck(phone: phoneMod)
        let userUID = Auth.auth().currentUser!.uid
        guard usedBy == nil else {
            AlertController.showAlert(self, title: "Phone error", message: "Phone number is already being used. Please contact us if this is an error.")
            return
        }
        self.phoneSave(phone: phoneMod, userID: userUID)
        self.performSegue(withIdentifier: "phoneVerifiedSegue", sender: nil)
    }
    func phoneCheck(phone: String) {
        guard phone.count == 10 else {
            AlertController.showAlert(self, title: "Phone error", message: "Phone number must be 10 digits.")
            return
        }
    }
    func phoneUser(phone: String) {
        let dbPhones = DatabaseAPI.shared.phonesReference
        dbPhones.child(String(phone)).observe(DataEventType.value, with: {(snapshot) in
            self.usedBy = snapshot.value as? String
        })
    }
    func phoneSave(phone: String, userID: String) {
        let dbPhones = DatabaseAPI.shared.phonesReference
        dbPhones.child(String(phone)).setValue(userID)
    }
}
