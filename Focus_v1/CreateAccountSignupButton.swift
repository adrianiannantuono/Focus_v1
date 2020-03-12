//
//  CreateAccountButton.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit

class CreateAccountSignUpButton: UIButton {
    
    
    override func didMoveToWindow() {
        
        self.backgroundColor = UIColor(named: "MainAccentColor")
        self.frame.size.height = 45
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .highlighted)
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = self.frame.height / 4
        self.layer.shadowOpacity = 0.075
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
