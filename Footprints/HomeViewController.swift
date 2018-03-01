//
//  HomeViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 3/1/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBAction func settingsTap(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func addRequestTap(_ sender: Any) {
        let alert = UIAlertController(title: "Prayer Request", message: "Add a request", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your prayer here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            print(text)
        }
        alert.addAction(cancel)
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        return cell
    }
}
