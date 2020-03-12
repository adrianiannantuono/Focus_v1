//
//  SettingsTableViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-03-11.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//
import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    var newViewController: UIViewController!

    @IBOutlet var logOutButton: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        self.tabBarController?.tabBar.isHidden = true
        
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
