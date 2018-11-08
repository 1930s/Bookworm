//
//  WelcomPageViewOneController.swift
//  BookWorm
//
//  The first sign up page that presented a cancel to go back
//
//  Other option begins account creation
//
//  Created by Hegde, Vikram on 6/21/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class WelcomePageOneViewController: UIViewController {

    // Page One
    @IBOutlet weak var bookwormLogo: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    let cache = ConstraintsSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookwormLogo.center.y = cache.getYCoor()
        bookwormLogo.frame.size.height = cache.getLogoHeight()
    }

}
