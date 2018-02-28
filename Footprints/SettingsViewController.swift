//
//  SettingsViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 2/26/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var greeting: UILabel!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        if let username = Auth.auth().currentUser?.displayName {
            greeting.text = "Hello " + username + "!"
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOutSegue", sender: nil)
        } catch {
            print(error)
        }
    }

}
