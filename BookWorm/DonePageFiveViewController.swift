//
//  DonePageFiveViewController.swift
//  BookWorm
//
//  Created by Hegde, Vandana on 6/23/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DonePageFiveViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    let cache = EmailAndPasswordSingleton.sharedInstance
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    @IBAction func goToMainScreen(_ sender: AnyObject) {
        if cache.getEmail() == "WRONG" {
            errorLabel.alpha = 1
            errorLabel.text = "Check the email field for ommision then submit."
        }else if cache.getPassword() == "WRONG"{
            errorLabel.alpha = 1
            errorLabel.text = "Check the password field for problems then submit."
        }else if cache.getPassword() == "SHORT"{
            errorLabel.alpha = 1
            errorLabel.text = "Password less than 6 letters. Please choose a longer password then submit."
        }else{
            
            errorLabel.alpha = 0
            
            // create and auth user
            FIRAuth.auth()?.createUser(withEmail: cache.getEmail(), password: cache.getPassword(), completion: { (user, error) in
                
                if error != nil {
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "There was a problem logging in please try again later."
                    print(error?.localizedDescription)
                }else{
                    self.ref.child(self.cache.getSchool()).child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(["email" : self.cache.getEmail()])
                    self.performSegue(withIdentifier: "signedUp", sender: nil)
                }
            })
        }
        
    }
}
