//
//  HomeViewController.swift
//  Footprints
//
//  Created by Daniel Nam on 3/1/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var prayers = [Prayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseAPI.shared.prayersReference.observe(DataEventType.value, with: {(snapshot) in
            guard let prayersSnapshot = PrayersSnapshot(with: snapshot) else { return }
            self.prayers = prayersSnapshot.prayers
            self.tableView.reloadData()
        })
    }
    
    @IBAction func settingsTap(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func addPrayer(_ sender: Any) {
        let alert = UIAlertController(title: "Prayer Request", message: "Add a request", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your prayer here"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            let userUID = Auth.auth().currentUser!.uid
            let username = Auth.auth().currentUser?.displayName ?? "Anonymous"
            
            let database = DatabaseAPI.shared
            let userID = database.usersReference.child(userUID)
            let prayerID = database.prayersReference.childByAutoId()
            
            let prayerIDString = String(describing: prayerID)
            let idStartIdx = prayerIDString.index(prayerIDString.startIndex, offsetBy: 49)
            let prayerIDShort = prayerIDString[idStartIdx...]
            
            let prayerParams = [
                "authorID"      : userUID,
                "authorName"    : username,
                "prayerRequest" : text,
                "date"          : String(describing: Date()),
                "answered"      : false,
                "footprints"    : 0
                ] as [String : Any]
            
            let userListParams = [
                "display"       : "show",
                "order"         : self.prayers.count
                ] as [String : Any]
            
            userID.child(String(prayerIDShort)).setValue(
            userListParams)
            prayerID.setValue(prayerParams)
            
            self.setupMessages(prayerID: String(prayerIDShort))
            self.setupIntercessors(prayerID: String(prayerIDShort))
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    
    func setupMessages(prayerID: String) {
        let messages = "Write a message!"
        let dbMessages = DatabaseAPI.shared.messagesReference
        dbMessages.child(String(prayerID)).setValue(messages)
    }
    
    func setupIntercessors(prayerID: String) {
        let intercessors = "Add some people!"
        let dbIntercessors = DatabaseAPI.shared.intercessorsReference
        dbIntercessors.child(String(prayerID)).setValue(intercessors)
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = prayers[indexPath.row].prayerRequest
        cell.detailTextLabel?.text = prayers[indexPath.row].authorName
        
        return cell
    }
}
