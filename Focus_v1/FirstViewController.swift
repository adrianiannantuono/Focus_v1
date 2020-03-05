//
//  FirstViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonClicked(_ sender: Any) {
        button.setTitle("test", for: UIControl.State.normal)
    }
    

}

