//
//  PasswordPageThreeViewController.swift
//  BookWorm
//
//  Third sign up page to ask for a password
//
//  Created by Hegde, Vikram on 6/23/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
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


class PasswordPageThreeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let cache = EmailAndPasswordSingleton.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        passwordField.delegate = self
        confirmField.delegate = self
        
        self.view.bindToKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if passwordField.text != "" && passwordField.text == confirmField.text{
            errorLabel.alpha = 0
            cache.newPassword(passwordField.text!)
        }else if passwordField.text != "" && confirmField.text != "" && passwordField.text != confirmField.text{
            errorLabel.text = "Passwords do not match."
            errorLabel.alpha = 1
            cache.newPassword("WRONG")
        }else{
            cache.newPassword("WRONG")
        }
        
        if passwordField.text?.characters.count < 6 {
            errorLabel.text = "Passwords must have more than 5 letters"
            errorLabel.alpha = 1
            cache.newPassword("SHORT")
        }
        if textField == passwordField {
            confirmField.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            return false
        }
        
        
    }
}
