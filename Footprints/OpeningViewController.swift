//
//  OpeningViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 2/28/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class OpeningViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(2)
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "goLogInSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "goLoggedInSegue", sender: self)
        }
    }
    
}
