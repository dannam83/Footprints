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
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        print("sign up pushed")
        guard
            let firstName = firstNameTF.text, firstName != "",
            let lastName = lastNameTF.text, lastName != "",
            let phone = phoneTF.text, phone != "",
            let email = emailTF.text, email != "",
            let password = passwordTF.text, password != ""
            else {
                AlertController.showAlert(self, title: "Incomplete form", message: "Please fill in all information.")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(self, title: "Error signing up", message: error!.localizedDescription)
                return
            }
            
            guard let user = user else {
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
            
            print(user.displayName ?? "no username")
            print(user.email ?? "no user")
            print(user.uid)
            
            self.performSegue(withIdentifier: "signedUpSegue", sender: nil)
        })
        
    }
    
}
