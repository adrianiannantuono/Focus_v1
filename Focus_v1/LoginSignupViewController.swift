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
    var databaseRef: DatabaseReference!
    
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
    
    var newViewController: UITabBarController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        databaseRef = Database.database().reference()
        
        newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "home") as! UITabBarController)
        newViewController.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser != nil) {
            self.present(self.newViewController, animated: false, completion: nil)
        }
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
        if (!emptyEmail()) {
            ret = true
        }
        if(!emptyPassword()) {
            ret = true
        }
        
        if (onCreateAccount == true) {
            if (!emptyName()) {
                ret = true
            }
            if (ret) {
                return
            } else {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, aError in
                    if (aError == nil) {
                        // Succesfully created an account
                        // Add to database
                        self.databaseRef.child("Users").child(Auth.auth().currentUser!.uid).setValue(["email" : self.emailField.text, "password" : self.passwordField.text, "firstname" : self.firstNameField.text, "lastname" : self.lastNameField.text])
                        
                        self.present(self.newViewController, animated: true, completion: nil)
                    } else {
                        // Error creating an account
                        if let errorCode = AuthErrorCode(rawValue: aError!._code) {
                            switch errorCode {
                                case .invalidEmail:
                                    self.emailError.text = "      Invalid email"
                                    self.emailField.layer.borderWidth = CGFloat(self.borderWidthError)
                                    print("Invalid email")
                                case .emailAlreadyInUse:
                                    self.emailError.text = "      Email already in use"
                                    self.emailField.layer.borderWidth = CGFloat(self.borderWidthError)
                                    print("Email in use")
                                case .weakPassword:
                                    self.passwordError.text = "      Password is too weak"
                                    self.passwordField.layer.borderWidth = CGFloat(self.borderWidthError)
                                    print("Password is too weak")
                                default:
                                    print("Could not create account: \(String(describing: aError))")
                            }
                        }
                        return
                    }
                }
            }
        } else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if (error == nil) {
                    // Succesfully logged in
                    self.present(self.newViewController, animated: true, completion: nil)
                } else {
                    // Error loggin in
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                            case .invalidEmail:
                                self.emailError.text = "      Invalid email"
                                self.emailField.layer.borderWidth = CGFloat(self.borderWidthError)
                                print("Invalid email")
                            default:
                                self.emailError.text = "      Email/Password invalid"
                                self.emailField.layer.borderWidth = CGFloat(self.borderWidthError)
                                print("Could not create account: \(String(describing: error))")
                        }
                    }
                    return
                }
            }
        }
        

    }
    
    func emptyPassword() -> Bool {
        if (onCreateAccount == true && passwordField.text == "" && reEnterPasswordField.text == ""){
            passwordError.text = "      Please enter a password"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordError.text = "      Please re-enter your password"
            return false
        } else if (onCreateAccount == true && passwordField.text == "" && reEnterPasswordField.text != "") {
            passwordError.text = "      Please enter a password"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        } else if (onCreateAccount == true && passwordField.text != "" && reEnterPasswordField.text == "") {
            reEnterPasswordError.text = "      Please re-enter your password"
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        } else if (onCreateAccount == true && passwordField.text != reEnterPasswordField.text) {
            passwordError.text = "      Passwords don't match"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            reEnterPasswordError.text = "      Passwords don't match"
            reEnterPasswordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        } else if (onCreateAccount == false && passwordField.text == "") {
            passwordError.text = "      Please enter a password"
            passwordField.layer.borderWidth = CGFloat(borderWidthError);
            return false
        }
        return true
    }
    
    func emptyName() -> Bool {
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
    
    func emptyEmail() -> Bool {
        var ret = true
        if (emailField.text == "") {
            emailField.layer.borderWidth = CGFloat(borderWidthError);
            emailError.text = "      Please enter an email"
            ret = false
        }
        return ret
    }
    
    
    
}

