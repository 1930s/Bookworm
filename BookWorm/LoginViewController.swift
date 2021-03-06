//
//  ViewController.swift
//  BookWorm
//
//  View Controller to handle the Login of different users
//
//  Incorporates FIRAuth
//
//  Created by Hegde, Vikram on 6/16/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

//facebook logins

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bookwormLogo: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let cache = ConstraintsSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isUserInteractionEnabled = false
        errorLabel.text = ""
        
        email.delegate = self
        password.delegate = self

        
        // if any of the fields change at all, update the singleton
        email.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        password.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: Animation of the logo and fields
        
        self.bookwormLogo.alpha = 0
        self.errorLabel.alpha = 0
        self.email.alpha = 0
        self.emailLine.alpha = 0
        self.password.alpha = 0
        self.passwordLine.alpha = 0
        self.doneButton.alpha = 0
        self.signUpButton.alpha = 0
        
        // MARK: Slide in animations on the fields
        
        self.bookwormLogo.center.x -= self.view.bounds.width
        self.email.center.x += self.view.bounds.width
        self.password.center.x += self.view.bounds.width
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.errorLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.3, options: [.curveEaseOut], animations: {
            self.email.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.emailLine.alpha = 0.5
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.6, options: [.curveEaseOut], animations: {
            self.password.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.passwordLine.alpha = 0.5
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            if self.password.text != "" && self.email.text != "" {
                self.doneButton.alpha = 0.9
                self.doneButton.isUserInteractionEnabled = true
            }else{
                self.doneButton.alpha = 0.2
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.signUpButton.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.bookwormLogo.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.bookwormLogo.center.x += self.view.bounds.width
            
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.3, options: [.curveEaseOut], animations: {
            self.email.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.6, options: [.curveEaseOut], animations: {
            self.password.center.x -= self.view.bounds.width
        }, completion: nil)
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        // Use FIRAuth to auth the user with email and password
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            if error != nil {
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Something went wrong. Please check the fields and try again later."
            }else{
                self.animateOut()
                UIView.animate(withDuration: 0.6, delay: 0.6, options: [.curveEaseOut], animations: {
                    self.bookwormLogo.alpha = 0.0
                }, completion: nil) // I was new to Swift now I know you can add it to completion blocks. This project was done in 2015-16
                self.delay(1.2){
                    // go to main view controller after a second
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }
            }
        })
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        self.animateOut()
        // Go to sign up view controller
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut], animations: {
            self.bookwormLogo.center.y = (self.view.bounds.height - 30)/2
            }, completion: nil)
        
        delay(1.6){
            // Move the logo
            self.cache.newYCoor(self.bookwormLogo.center.y)
            self.cache.newLogoHeight(self.bookwormLogo.frame.height)
            self.performSegue(withIdentifier: "signUp", sender: nil)
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        // If the fields change and the text is incorrect then the user
        // cannot sign in, so make the button unable to function
        if email.text != "" && password.text != ""{
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
                self.doneButton.alpha = 0.9
                }, completion: nil)
            doneButton.isUserInteractionEnabled = true
        }else{
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
                self.doneButton.alpha = 0.2
                }, completion: nil)
            doneButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == email {
            password.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            return false
        }
    }
    
    // Didn't know there was a native delay, also I never use these anymore, as they cut the program flow
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // Move all the fields to just off for the animation in.
    func animateOut(){
        // MARK: Animations
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.errorLabel.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.email.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.emailLine.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.password.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.passwordLine.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.doneButton.alpha = 0.0
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            self.signUpButton.alpha = 0.0
            }, completion: nil)
    }
}

extension UIView{
    // Moves the field with the keyboard.
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    // Adds the function I found online to change a textfield and update when changed
    func keyboardWillChange(_ notification: Notification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        // MARK: Animation
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y+=deltaY
            
            },completion: nil)
        
    }  
}

extension UIImageView {
    // fids an image from a URL and sets the image from the UIImageView to the ImageView
    public func imageFromUrl(_ urlStringWithoutJPEG: String) {
        let urlString = urlStringWithoutJPEG + ".jpeg"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { (response, data, error) in
                self.image = UIImage(data: data!)
            })
        }
    }
}


