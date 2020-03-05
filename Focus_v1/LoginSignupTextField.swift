//
//  LoginSignupTextField.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit

class LoginSignupTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    override func didMoveToWindow() {
        self.backgroundColor = UIColor(named: "TextFieldColor")
        self.layer.borderColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1).cgColor
        self.frame.size.height = 45
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.shadowColor = UIColor.systemGray2.cgColor
        self.layer.shadowRadius = self.frame.height / 4
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
