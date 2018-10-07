//
//  MyInfoViewController.swift
//  BookWorm
//
//  Created by Hegde, Vandana on 8/3/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import Firebase

class MyInfoViewController: UIViewController {
    @IBOutlet weak var welcomeNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let email : String! = FIRAuth.auth()?.currentUser?.email
        let name : String! = email!.substring( to: email.characters.index(of: "@")!)
        
        welcomeNameLabel.text = "Welcome, \(name!)"
    }
    
    @IBAction func logoutUser(_ sender: AnyObject){
        try! FIRAuth.auth()!.signOut()
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
}
