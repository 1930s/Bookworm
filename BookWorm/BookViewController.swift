//
//  BookViewController.swift
//  BookWorm
//
//  View Controller to view a single Book. Displays all relavent information.
//
//  Includes all information from the Book Struct above.
//
//  Created by Hegde, Vikram on 9/9/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class BookViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var edition: UILabel!
    @IBOutlet weak var contactUser: UIButton!
    
    var isMyBook = false // whether or not to include a buy button
    var myBook : Book = Book(isbn: "0", title: "An Error Occured", author: "0", edition: "0", price: "0", uid: "0",index: 0) // for the book model
    var pathSellingOrBuying : String = ""
    var cover : UIImage = UIImage(named: "noPhotoSelected")!
    let ref = FIRDatabase.database().reference()
    var school : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email: String! = FIRAuth.auth()?.currentUser?.email!
        school = email!.substring(with: Range(email.index(email!.characters.index(of: "@")!, offsetBy: 1) ..< email!.characters.index(of: ".")!)) // the school of the user


        bookTitle.text = myBook.title
        authors.text = "By: \(myBook.author)"
        price.text = "Price: $\(myBook.price)"
        edition.text = myBook.edition
        let storageRef = FIRStorage.storage().reference(forURL: "gs://bookworm-9f703.appspot.com").child("\(myBook.isbn)-\(myBook.uid).png")
        self.coverImage.image = UIImage(named: "loadingCover")//LOADING
        storageRef.data(withMaxSize: 10000*10000, completion: { (data, error) in
            if error == nil {
                self.coverImage.image = UIImage(data: data!)
            }else{
                print(error!.localizedDescription)
                self.coverImage.image = UIImage(named: "noPhotoSelected")
            }
        })
        
        if myBook.uid == FIRAuth.auth()!.currentUser!.uid {
            contactUser.backgroundColor = UIColor.init(red:1, green:0.35, blue: 0.35, alpha: 1)
            contactUser.setTitle("Delete This Entry", for: UIControlState())
            contactUser.setTitleColor(UIColor.init(red:255,green:255,blue: 255,alpha: 0.9), for: UIControlState())
            isMyBook = true
        }
    }
    
    @IBAction func performButtonFunction(_ sender: AnyObject) { // can be remove or message user
        if isMyBook {
            // Delete if the book is yours book
            let refreshAlert = UIAlertController(title: "Are you sure?", message: "Deleting an entry is permanent.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                self.ref.child(self.school).child(self.pathSellingOrBuying).child(self.myBook.index.description).updateChildValues(["isDeleted" : true]) // Delete the entry using isDeleted flag in server
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                refreshAlert.dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
            return
        }
        
        // Email the owner of the book that you are interesting in buying it.
        ref.child(school).child("users").child(myBook.uid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            if let email = snapshot.value as? String{
                self.sendEmail(email)
            }else{
                print("Something went wrong with sending an email.")
            }
            
        })
        
    }
    
    // This function sends an email to the owner of a book to ask if they want a book
    func sendEmail(_ recipient : String) {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([recipient])
        mailVC.setSubject("Interested in your copy of \(bookTitle.text!)")
        mailVC.setMessageBody("Hi there. I am interested in buying your book.", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    // MARK: - Email Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
