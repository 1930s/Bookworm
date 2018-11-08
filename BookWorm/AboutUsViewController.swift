//
//  AboutUsViewController.swift
//  BookWorm
//
//  A little information on the developers and the company
//
//  Just for college mainly
//
//  Created by Hegde, Vikram on 9/11/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import MessageUI

class AboutUsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func rate(_ sender: AnyObject) {
        UIApplication.shared.openURL(NSURL(string : "itunes.apple.com/app/id1182481456")! as URL)
    }
    
    @IBAction func emailUs(_ sender: AnyObject) {
        sendEmail()
    }
    
    func sendEmail() {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["bookwormapp@gmail.com"])
        mailVC.setSubject("Suggestion: ")
        mailVC.setMessageBody("", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    // MARK: - Email Delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
