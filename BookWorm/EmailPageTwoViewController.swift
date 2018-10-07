//
//  EmailPageTwoViewController.swift
//  BookWorm
//
//  Created by Hegde, Vandana on 6/22/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class EmailPageTwoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var youEmailField: UITextField!
    @IBOutlet weak var schoolEmailField: UITextField!
    
    @IBOutlet weak var edu: UILabel!
    @IBOutlet weak var atSymbol: UILabel!
    @IBOutlet weak var youLine: UIView!
    @IBOutlet weak var schoolLine: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var problematicLayout: NSLayoutConstraint!
    
    @IBOutlet weak var problematicLayoutTwo: NSLayoutConstraint!
    let cache = EmailAndPasswordSingleton.sharedInstance
    var email : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*if (UIScreen.mainScreen().bounds.size.height <= 481) {
            problematicLayout.constant = 90
            problematicLayoutTwo.constant = 50
        }*/
        
        self.view.bindToKeyboard()
        
        youEmailField.delegate = self
        schoolEmailField.delegate = self
        youEmailField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        schoolEmailField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (UIScreen.main.bounds.size.height <= 481) {
//            problematicLayout.constant = 175
//            problematicLayoutTwo.constant = 50
//        }
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if (UIScreen.main.bounds.size.height <= 481) {
//            problematicLayout.constant = 90
//            problematicLayoutTwo.constant = 50
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == youEmailField {
            schoolEmailField.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            return false
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if youEmailField.text != "" && schoolEmailField.text != ""{
            email = "\(youEmailField.text!)@\(schoolEmailField.text!).edu"
            cache.newEmail(email)
            cache.newSchool(schoolEmailField.text!)
        }else{
            email = "WRONG"
            cache.newEmail(email)
            cache.newSchool("")
        }
    }
}
