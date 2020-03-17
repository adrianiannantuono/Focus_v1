//
//  SettingsTableViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-03-11.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {
    var databaseRef = Database.database().reference()
    var user: User!
    var newViewController: UIViewController!

    @IBOutlet var logOutButton: UITapGestureRecognizer!
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        view.backgroundColor = UIColor.systemBackground
        
        databaseRef.child("Users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          self.email.text = (value?["email"] as? String ?? "")
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        let logOutAlert = UIAlertController(title: "Are you sure you would like to log out?", message: nil, preferredStyle: .actionSheet)
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
            try! Auth.auth().signOut()
            self.newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "logInSignUp"))
            self.newViewController.modalPresentationStyle = .fullScreen
            self.present(self.newViewController, animated: true, completion: nil)
        }))
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(logOutAlert, animated: true)
        

    }
    
}
