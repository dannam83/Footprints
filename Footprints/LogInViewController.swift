//
//  LogInViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 2/26/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func logInButton(_ sender: Any) {
        
        guard let email = emailTF.text, email != "" else {
            AlertController.showAlert(self, title: "Missing Email", message: "Please enter your email.")
            return
        }
        guard let password = passwordTF.text, password != "" else {
            AlertController.showAlert(self, title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(self, title: "Login Error", message: error!.localizedDescription)
                return
            }
            
            guard let user = user else {
                AlertController.showAlert(self, title: "Login Error", message: "Error. Please try again.")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error Logging In", message: error!.localizedDescription)
                    return
                }
            })
            
            print(user.uid)
            print(user.displayName ?? "no username")
            print(user.email ?? "no email")
            
            self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            
            })
        
    }
    
}
