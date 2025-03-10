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
    
    @IBOutlet weak var orderButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var prayers = [Prayer]()
    let userUID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseAPI.shared.usersReference.child(self.userUID).observe(DataEventType.value, with: {(snapshot) in
            guard let prayersSnapshot = PrayersSnapshot(with: snapshot) else { return }
            self.prayers = prayersSnapshot.prayers
            self.prayers = self.prayers.sorted(by: { $0.order > $1.order })
            self.tableView.reloadData()
        })
            self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    @IBAction func settingsTap(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        switch tableView.isEditing {
        case true:
            editButton.title = "done"
        default:
            editButton.title = "edit"
        }
    }
    
    @IBAction func addPrayer(_ sender: Any) {
        let alert = UIAlertController(title: "Prayer Request", message: "Add a request", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your prayer here"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            let username = Auth.auth().currentUser?.displayName ?? "Anonymous"
            
            let database = DatabaseAPI.shared
            let userID = database.usersReference.child(self.userUID)
            let prayerID = database.prayersReference.childByAutoId()
            
            let prayerIDString = String(describing: prayerID)
            let idStartIdx = prayerIDString.index(prayerIDString.startIndex, offsetBy: 49)
            let prayerIDShort = prayerIDString[idStartIdx...]
            
            let prayerParams = [
                "prayerID"      : prayerIDShort,
                "authorID"      : self.userUID,
                "authorName"    : username,
                "prayerRequest" : text,
                "date"          : String(describing: Date()),
                "answered"      : false,
                "footprints"    : 0
                ] as [String : Any]
            
            let userListParams = [
                "authorID"      : self.userUID,
                "authorName"    : username,
                "prayerID"      : prayerIDShort,
                "prayerRequest" : text,
                "date"          : String(describing: Date()),
                "answered"      : false,
                "footprints"    : 0,
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let prayer = self.prayers[indexPath.row]
            let prayerID = prayer.prayerID
            let db = DatabaseAPI.shared
            let user = db.usersReference.child(self.userUID)
            if self.userUID == prayer.authorID {
                db.messagesReference.child(prayerID).setValue(nil)
                db.prayersReference.child(prayerID).setValue(nil)

//              need to setup deletion of prayer from each intercessor

            }
            let i = indexPath.row
            if i > 0 {
                for p in self.prayers[...i] {
                    let newOrder = p.order - 1
                    user.child(p.prayerID).child("order").setValue(newOrder)
                }
            }
            if self.prayers.count == 1 {
                user.setValue("Deleted all requests")
                self.prayers.remove(at: 0)
                self.tableView.reloadData()
            } else {
                user.child(prayerID).setValue(nil)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let prayer = self.prayers[sourceIndexPath.row]
        let database = DatabaseAPI.shared
        let userID = database.usersReference.child(self.userUID)
        let start = sourceIndexPath.row
        let end = destinationIndexPath.row
        let change = end - start
        let newOrder = prayer.order - change
        var reorderPrayers = [Prayer]()
        if (change > 0) {
            reorderPrayers = reorderPrayers + prayers[start + 1...end]
        } else if (change < 0){
            reorderPrayers = reorderPrayers + prayers[end...start - 1]
        }
        userID.child(String(prayer.prayerID)).child("order").setValue(newOrder)
        for p in reorderPrayers {
            if (change > 0) {
                let shift = p.order + 1
                userID.child(String(p.prayerID)).child("order").setValue(shift)
            } else if (change < 0){
                let shift = p.order - 1
                userID.child(String(p.prayerID)).child("order").setValue(shift)
            }
        }
        self.prayers.remove(at: start)
        self.prayers.insert(prayer, at: end)
    }
}
