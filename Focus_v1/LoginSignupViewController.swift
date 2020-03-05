//
//  LoginSignupViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class LoginSignupViewController: UIViewController {
    var dRef = Database.database().reference()
    
    var onCreateAccount = true
    var borderWidthError = 1
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var firstNameField: LoginSignupTextField!
    @IBOutlet weak var lastNameField: LoginSignupTextField!
    @IBOutlet weak var emailField: LoginSignupTextField!
    @IBOutlet weak var reEnterPasswordField: LoginSignupTextField!
    
    @IBOutlet weak var passwordField: LoginSignupTextField!
    
   
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
       @IBOutlet weak var reEnterPasswordError: UILabel!
    @IBOutlet weak var changeViewButton: UIButton!
     
    @IBOutlet weak var createAccountSignUpButton: CreateAccountSignUpButton!
    
    var newStoryBoard: UIStoryboard!
    var newViewController: UITabBarController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        newStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        newViewController = (newStoryBoard.instantiateViewController(withIdentifier: "home") as! UITabBarController)
        newViewController.modalPresentationStyle = .fullScreen
    }
    
    

    @IBAction func onChangeSignInOrSignUp(_ sender: Any) {
        if (onCreateAccount == true) {
            firstNameField.isHidden = true;
            lastNameField.isHidden = true;
            reEnterPasswordField.isHidden = true;
            firstNameError.isHidden = true;
            lastNameError.isHidden = true;
            reEnterPasswordError.isHidden = true;
            changeViewButton.setTitle("Don't have an account? Sign Up", for: UIControl.State.normal)
            createAccountSignUpButton.setTitle("Log In", for: UIControl.State.normal)
            mainTitle.text = "Log In"
            onCreateAccount = false;
        } else {
            firstNameField.isHidden = false;
            lastNameField.isHidden = false;
            reEnterPasswordField.isHidden = false;
            firstNameError.isHidden = false;
            lastNameError.isHidden = false;
            reEnterPasswordError.isHidden = false;
            changeViewButton.setTitle("Already have an account? Log In", for: UIControl.State.normal)
            createAccountSignUpButton.setTitle("Create Account", for: UIControl.State.normal)
            mainTitle.text = "Create an Account"
            onCreateAccount = true;
        }
        firstNameError.text = ""
        lastNameError.text = ""
        emailError.text = ""
        passwordError.text = ""
        reEnterPasswordError.text = ""
        firstNameField.layer.borderWidth = 0
        lastNameField.layer.borderWidth = 0
        emailField.layer.borderWidth = 0
        passwordField.layer.borderWidth = 0
        reEnterPasswordField.layer.borderWidth = 0
    }
    @IBAction func onCreateAccountSignUp(_ sender: Any) {
        firstNameError.text = ""
        lastNameError.text = ""
        emailError.text = ""
        passwordError.text = ""
        reEnterPasswordError.text = ""
        firstNameField.layer.borderWidth = 0
        lastNameField.layer.borderWidth = 0
        emailField.layer.borderWidth = 0
        passwordField.layer.borderWidth = 0
        reEnterPasswordField.layer.borderWidth = 0
        var ret = false;
        if (onCreateAccount == true) {
            if (!validName()) {
                ret = true
            }
            if (!validEmail()) {
                ret = true
            }
            if(!validPassword()) {
                ret = true
            }
            if (ret) {
                return
            } else {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                    if (error == nil) {
                        // Succesfully created an account
                        self.present(self.newViewController, animated: true, completion: nil)
                    } else {
                        // Error creating an account
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                                case .invalidEmail:
                                    self.emailError.text = "      Invalid email"
                                    print("Invalid email")
                                case .emailAlreadyInUse:
                                    self.emailError.text = "      Email already in use"
                                    print("Email in use")
                                case .weakPassword:
                                    self.passwordError.text = "      Password is too weak"
                                    print("Password is too weak")
                                default:
                                    print("Could not create account: \(String(describing: error))")
                            }
                        }
                        return
                    }
                }
            }
        } else {
            
        }
        

    }
    
    func validPassword() -> Bool {
        if (passwordField.text == "" && reEnterPasswordField.text == ""){
            passwordError.text = "      Please enter a password"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordError.text = "      Please re-enter your password"
            return false
        } else if (passwordField.text == "" && reEnterPasswordField.text != "") {
            passwordError.text = "      Please enter a password"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        } else if (passwordField.text != "" && reEnterPasswordField.text == "") {
            reEnterPasswordError.text = "      Please re-enter your password"
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        } else if (passwordField.text != reEnterPasswordField.text) {
            passwordError.text = "      Passwords don't match"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordError.text = "      Passwords don't match"
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        }
        return true
    }
    
    func validName() -> Bool {
        var ret = true
        if (firstNameField.text == "") {
            firstNameField.layer.borderWidth = CGFloat(borderWidthError);
            firstNameError.text = "      Enter your first name"
            ret = false
        }
        if (lastNameField.text == "") {
            lastNameField.layer.borderWidth = CGFloat(borderWidthError);
            lastNameError.text = "      Enter your last name"
            ret = false
        }
        return ret
    }
    
    func validEmail() -> Bool {
        var ret = true
        if (emailField.text == "") {
            emailField.layer.borderWidth = CGFloat(borderWidthError);
            emailError.text = "      Please enter an email"
            ret = false
        }
        return ret
    }
    
    
    
}

