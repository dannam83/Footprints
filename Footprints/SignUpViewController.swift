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
                
                print(user.displayName ?? "no username")
                print(user.email ?? "no email")
                print(user.uid)
                
                self.performSegue(withIdentifier: "signedUpSegue", sender: nil)
                
            })
        })
        
    }
    
}
