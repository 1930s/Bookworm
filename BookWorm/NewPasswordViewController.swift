//
//  NewPasswordViewController.swift
//  BookWorm
//
//  View Controller to set a password.
//  Just needs the new password since user
//  is authed from opening the app
//
//  Created by Hegde, Vikram on 9/11/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class NewPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        passwordField.delegate = self
        confirmField.delegate = self
        
        self.view.bindToKeyboard()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.alpha = 0
        doneButton.isUserInteractionEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if passwordField.text != "" && passwordField.text == confirmField.text{
            errorLabel.alpha = 0
            doneButton.alpha = 0.9
            doneButton.isUserInteractionEnabled = true
        }else if passwordField.text != "" && confirmField.text != "" && passwordField.text != confirmField.text{
            errorLabel.text = "Passwords do not match."
            errorLabel.alpha = 1
            doneButton.alpha = 0.2
            doneButton.isUserInteractionEnabled = false
        }else{
            errorLabel.text = "Passwords do not match."
            errorLabel.alpha = 1
            doneButton.alpha = 0.2
            doneButton.isUserInteractionEnabled = false
        }
        
        if passwordField.text?.characters.count < 6 {
            errorLabel.text = "Passwords must have more than 5 letters"
            errorLabel.alpha = 1
        }
        
        if textField == passwordField{
            confirmField.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            return false
        }
    }
    
    @IBAction func changePassword(_ sender: AnyObject) {
        FIRAuth.auth()?.currentUser?.updatePassword(passwordField.text!, completion: { (error) in
            if error != nil {
                print(error?.localizedDescription)
                self.errorLabel.text = "Something went wrong, please try again later."
                return
            }
            self.performSegue(withIdentifier: "toMain", sender: nil)
        })
    }
}
