//
//  FirstViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirstViewController: UIViewController {
    var dRe = Database.database().reference()
    
    @IBOutlet weak var button: UIButton!
    
    var newViewController: UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonClicked(_ sender: Any) {
        try! Auth.auth().signOut()
        newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "logInSignUp"))
        newViewController.modalPresentationStyle = .fullScreen
        self.present(self.newViewController, animated: true, completion: nil)
        
    }
    

}

