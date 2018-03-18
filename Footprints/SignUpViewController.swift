//
//  SignUpViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 2/26/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        guard
            let firstName = firstNameTF.text, firstName != "",
            let lastName = lastNameTF.text, lastName != "",
            let email = emailTF.text, email != "",
            let password = passwordTF.text, password != ""
            else {
                AlertController.showAlert(self, title: "Incomplete form", message: "Please fill in all information.")
                return
        }
        
//        self.phoneFormatCheck(phone: phoneMod)
        guard password == confirmPasswordTF.text else {
            AlertController.showAlert(self, title: "Error signing up", message: "Password and password confirmation must match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error signing up", message: error!.localizedDescription)
                return
            }
            
            if user == nil {
                AlertController.showAlert(self, title: "Error signing up", message: "Error. Please try again.")
                return
            }

            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = firstName + " " + lastName
            changeRequest?.commitChanges(completion: { (error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
            })
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                guard let user = user, error == nil else {
                    AlertController.showAlert(self, title: "Error logging in", message: "Your account is all set, but try logging in again.")
                    self.performSegue(withIdentifier: "retryLogInSegue", sender: nil)
                    return
                }
                let emailMod = email.replacingOccurrences(of: ".", with: "")
                self.emailSave(email: emailMod, userID: user.uid)
                self.userSave(userID: user.uid)
                self.performSegue(withIdentifier: "phoneVerifySegue", sender: nil)
            })
        })
    }
    
//    func phoneFormatCheck(phone: String) {
//        guard phone.count == 10 else {
//            AlertController.showAlert(self, title: "Error signing up", message: "Phone number must be 10 digits.")
//            return
//        }
//        for char in phone {
//            guard "1234567890".contains(char) else {
//                AlertController.showAlert(self, title: "Error signing up", message: "Phone number cannot have letters.")
//                return
//            }
//        }
//    }
//
//    func phoneUser(phone: String) -> String? {
//        print("in phone check")
//        let dbPhones = DatabaseAPI.shared.phonesReference
//        var usedBy: String?
//        dbPhones.child(String(phone)).observe(DataEventType.value, with: {(snapshot) in
//            print("snapshot below")
//            print(snapshot.value as Any)
//            print("snapshot above")
//            usedBy = snapshot.value as? String
//        })
//        return usedBy
//    }
//
//    func phoneSave(phone: String, userID: String) {
//        let dbPhones = DatabaseAPI.shared.phonesReference
//        dbPhones.child(String(phone)).setValue(userID)
//    }
    
    func emailSave(email: String, userID: String) {
        let dbEmails = DatabaseAPI.shared.emailsReference
        dbEmails.child(String(email)).setValue(userID)
    }
    func userSave(userID: String) {
        let dbUsers = DatabaseAPI.shared.usersReference
        dbUsers.child(String(userID)).setValue("No requests")
    }
}
