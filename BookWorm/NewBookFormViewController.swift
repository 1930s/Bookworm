//
//  BookDetailsViewController.swift
//  BarcodeScanning
//
//  Uses the number generated from the last VC
//  to find the books using Google Books API and the BooksDetailFinder helper class
//
//  Created by Hegde, Vikram on 6/28/16.
//  Copyright © 2016 Jordan Morgan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class NewBookFormViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isbn : String =  "0321885171" //"4201337690" Strting
    var hasISBN = false
    var bookIndex : Int = 0;
    let ref = FIRDatabase.database().reference()
    var foundBook = false // to see if we found book in google API
    var school : String! = ""
    var newIndex : Int = 0

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorsField: UITextField!
    @IBOutlet weak var editionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ISBNField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet var fullView: UIView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var tapToChangeImage: UILabel!
    @IBOutlet weak var priceLayout: NSLayoutConstraint!
    
    @IBOutlet weak var haveBookButton: UIButton!
    @IBOutlet weak var wantBookButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullView.bindToKeyboard()
        errorLabel.alpha = 0
        
        if hasISBN{
            ISBNField.text = isbn
            titleField.text = "Fetching title..."
            authorsField.text = "Fetching authors..."
            getBookInfo()
        }
        
        titleField.delegate = self
        authorsField.delegate = self
        editionField.delegate = self
        priceField.delegate = self
        ISBNField.delegate = self
        
        let email = FIRAuth.auth()?.currentUser?.email!
        school = email!.substring(with: Range(email!.index(email!.characters.index(of: "@")!, offsetBy: 1) ..< email!.characters.index(of: ".")!))

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bookCoverImage.alpha = 0
        tapToChangeImage.alpha = 0
        haveBookButton.alpha = 0
        wantBookButton.alpha = 0
        priceLayout.constant = 8
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            authorsField.becomeFirstResponder()
            return true
        }else if textField == authorsField {
            ISBNField.becomeFirstResponder()
            return true
        }else if textField == ISBNField {
            editionField.becomeFirstResponder()
            return true
        }else if textField == editionField {
            priceField.becomeFirstResponder()
            return true
        }else{
            self.view.endEditing(true)
            bookCoverImage.alpha = 1
            tapToChangeImage.alpha = 1
            haveBookButton.alpha = 1
            wantBookButton.alpha = 1
            priceLayout.constant = 88
            return false
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        bookCoverImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        titleField.resignFirstResponder()
        authorsField.resignFirstResponder()
        ISBNField.resignFirstResponder()
        editionField.resignFirstResponder()
        priceField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        // Only allow photos to be picked, not taken.
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
        }else{
            imagePickerController.sourceType = .photoLibrary
        }
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func getBookInfo(){
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        self.delay(7){
            if !self.foundBook{
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Having trouble finding that. Please enter book manually."
                self.titleField.text = ""
                self.authorsField.text = ""
                return
            }
        }
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorLabel.alpha = 1
                    self.titleField.text  = ""
                    self.authorsField.text = ""
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []), let arrayOfTitles = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.title") as? [String], let arrayOfAuthors = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.authors") as? [[String]], let arrayOfImageURLs = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.imageLinks.thumbnail") as? [String]{
                    DispatchQueue.main.async {
                        self.titleField.text = arrayOfTitles.joined(separator: "")
                        self.authorsField.text = arrayOfAuthors.description.substring(with: Range<String.Index>(arrayOfAuthors.description.characters.index(arrayOfAuthors.description.startIndex, offsetBy: 2) ..< arrayOfAuthors.description.characters.index(arrayOfAuthors.description.endIndex, offsetBy: -2))).replacingOccurrences(of: "\"", with: "")
                        self.bookCoverImage.imageFromUrl(arrayOfImageURLs.joined(separator: ""))
                        self.foundBook = true
                    }
                }
                
            }).resume()
        }
    }
    
    @IBAction func userWantsBook(_ sender: UIButton) {
        if titleField.text == "" || authorsField.text == "" || priceField.text == "" || ISBNField.text == ""{
            errorLabel.alpha = 1
            errorLabel.text = "Please fill all applicable fields."
            return
        }
        
        spinner.startAnimating()
        
        let email = FIRAuth.auth()?.currentUser?.email!
        let school = email!.substring(with: Range(email!.index(email!.characters.index(of: "@")!, offsetBy: 1) ..< email!.characters.index(of: ".")!))
        
        fixFields()
        addImageToStorage()
        
        ref.child(school).child("buying").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let book : [AnyHashable: Any] = ["uid": (FIRAuth.auth()?.currentUser?.uid)!,
                "title": self.titleField.text!,
                "authors": self.authorsField.text!,
                "edition": self.editionField.text!,
                "price": self.priceField.text!,
                "isbn" : self.ISBNField.text!,
                "isDeleted" : false]
            
            if let booksJSON = snapshot.value as? NSArray{
                let bookRef = self.ref.child(school).child("buying").child(booksJSON.count.description)
                bookRef.updateChildValues(book, withCompletionBlock: { (NSError, FIRDatabaseReference) in //update the book in the db
                    self.performSegue(withIdentifier: "backToMain", sender: nil) // and after that go back to main
                })
            }else{
                let bookRef = self.ref.child(school).child("buying").child("0")
                bookRef.updateChildValues(book, withCompletionBlock: { (NSError, FIRDatabaseReference) in //update the book in the db
                    self.performSegue(withIdentifier: "backToMain", sender: nil) // and after that go back to main
                })
            }
            
            return
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func userHasBook(_ sender: AnyObject) { // USER IS SELLING
        if titleField.text == "" || authorsField.text == "" || priceField.text == "" || ISBNField.text == ""{
            errorLabel.alpha = 1
            errorLabel.text = "Please fill all applicable fields."
            return
        }
        
        self.spinner.startAnimating()
        let email = FIRAuth.auth()?.currentUser?.email!
        let school = email!.substring(with: Range(email!.index(email!.characters.index(of: "@")!, offsetBy: 1) ..< email!.characters.index(of: ".")!))
        
        fixFields()
        addImageToStorage()
        
        ref.child(school).child("selling").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let book : [AnyHashable: Any] = ["uid": (FIRAuth.auth()?.currentUser?.uid)!,
                "title": self.titleField.text!,
                "authors": self.authorsField.text!,
                "edition": self.editionField.text!,
                "price": self.priceField.text!,
                "isbn" : self.ISBNField.text!,
                "isDeleted" : false]

            if let booksJSON = snapshot.value as? NSArray{
                let bookRef = self.ref.child(school).child("selling").child(booksJSON.count.description)
                bookRef.updateChildValues(book, withCompletionBlock: { (NSError, FIRDatabaseReference) in //update the book in the db
                    self.performSegue(withIdentifier: "backToMain", sender: nil) // and after that go back to main
                })
            }else{
                let bookRef = self.ref.child(school).child("selling").child("0")
                bookRef.updateChildValues(book, withCompletionBlock: { (NSError, FIRDatabaseReference) in //update the book in the db
                    self.performSegue(withIdentifier: "backToMain", sender: nil) // and after that go back to main
                })
            }
            
            return
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addImageToStorage(){ // Adds image to firebase storage
        if self.bookCoverImage.image == UIImage.init(named: "noPhotoSelected"){
        }else{
            var storageRef = FIRStorage.storage().reference(forURL: "gs://bookworm-9f703.appspot.com");
            if let user = FIRAuth.auth()?.currentUser?.uid{
                storageRef = storageRef.child("\(self.ISBNField.text!)-\(user).png")
            }else{
                storageRef = storageRef.child("\(self.ISBNField.text!)-\(FIRAuth.auth()?.currentUser?.uid).png") // Never happens hopefully
            }
            
            if let uploadData = UIImagePNGRepresentation(self.bookCoverImage.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                })
            }
        }

    }
    
    func fixFields(){
        
        if Int(ISBNField.text!)! == 0 || Double(priceField.text!)! == 0 {
            errorLabel.alpha = 1
            errorLabel.text = "Please enter valid ISBN and Price."
            return
        }
        
        if self.editionField.text == "" {
            self.editionField.text = "Only Edition"
        }else{
            self.editionField.text = "Edition: \(self.editionField.text!)"
        }
        
        if self.priceField.text?.characters.contains(".") == false{
            self.priceField.text = (self.priceField.text)! + ".00"
        }

    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}
