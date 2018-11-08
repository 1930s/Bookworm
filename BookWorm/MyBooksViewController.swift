//
//  MyBooksViewController.swift
//  BookWorm
//
//  Class to see all book listings made by a single User
//
//  Created by Hegde, Vikram on 9/11/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit
import Firebase

class MyBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let ref = FIRDatabase.database().reference()
    var school : String = ""
    var noEntries = false
    var books : [Book] = []
    var allBooks : [Book] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var divider: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Division: ", divider.selectedSegmentIndex)
        
        let email: String! = FIRAuth.auth()?.currentUser?.email!
        school = email!.substring(with: Range(email.index(email!.characters.index(of: "@")!, offsetBy: 1) ..< email!.characters.index(of: ".")!))
        
        addBooksToArray()
    }
    
    
    @IBAction func dividerChanged(_ sender: AnyObject) {
        self.addBooksToArray()
    }
    
    // MARK: Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noEntries {
            return 1
        }
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        cell.backgroundColor  = UIColor.init(white: 255, alpha: 0)
        if(self.noEntries){
            cell.titleLabel.alpha = 0
            cell.coverImage.alpha = 0
            cell.editionLabel.alpha = 0
            cell.authorsLabel.alpha = 0
            cell.noBookLabel.alpha = 1
            cell.book = nil
        }else{
            cell.titleLabel.alpha = 1
            cell.coverImage.alpha = 1
            cell.editionLabel.alpha = 1
            cell.authorsLabel.alpha = 1
            cell.noBookLabel.alpha = 0
            
            cell.coverImage.image = UIImage(named: "loadingCover")
            
            // Load the book images from the database Firestore
            let storageRef = FIRStorage.storage().reference(forURL: "gs://bookworm-9f703.appspot.com").child("\(books[indexPath.row].isbn)-\(books[indexPath.row].uid).png")
            storageRef.data(withMaxSize: 5000*5000, completion: { (data, error) in
                if error == nil {
                    cell.coverImage.image = UIImage(data: data!)
                }else{
                    print(error!.localizedDescription)
                    cell.coverImage.image = UIImage(named: "noPhotoSelected")
                }
            })
            cell.titleLabel.text = self.books[indexPath.row].title
            cell.authorsLabel.text = self.books[indexPath.row].author
            cell.editionLabel.text = self.books[indexPath.row].edition
            cell.book = self.books[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if noEntries {
            return
        }
        performSegue(withIdentifier: "bookSelected", sender: indexPath.row)
    }
    
    // Gets a users books that they are buying and selling
    // Realize in 2018 that they can be loaded once and toggeled just in appearance anf cuntionality rather than reloading it.
    func addBooksToArray(){
        if self.divider.selectedSegmentIndex == 0{
            // Get all the books the user has and is attempting to sell
            self.ref.child(self.school).child("selling").observeSingleEvent(of: .value, with: {    (snapshot) in
                self.books.removeAll()
                if let booksJSON = snapshot.value as? NSArray{
                    self.noEntries = false
                    var index = 0
                    for bookJSON in booksJSON as! [[String: AnyObject]]{
                        let tempAuthor = bookJSON["authors"] as! String
                        let tempTitle = bookJSON["title"] as! String
                        let tempEdition = bookJSON["edition"] as! String
                        let tempPrice = bookJSON["price"] as! String
                        let tempISBN = bookJSON["isbn"] as! String
                        let tempUID = bookJSON["uid"] as! String
                        let isDeleted = bookJSON["isDeleted"] as! Bool
                        if !isDeleted  && tempUID == FIRAuth.auth()!.currentUser!.uid{
                            // Load the model with the loaded books and add to the model array
                            self.books.append(Book(isbn: tempISBN, title: tempTitle, author: tempAuthor, edition: tempEdition, price: tempPrice, uid: tempUID, index: index))
                            self.noEntries = false
                        }
                        if(self.books.count == 0){
                            self.noEntries = true
                        }
                        index += 1
                    }
                }else{
                    self.noEntries = true
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }) { (error) in
                print(error.localizedDescription)
            }
        }else if self.divider.selectedSegmentIndex == 1{
            // Getting the books a user is attempting to purchase
            self.books.removeAll()
            self.ref.child(self.school).child("buying").observeSingleEvent(of: .value, with: {    (snapshot) in
                if let booksJSON = snapshot.value as? NSArray{
                    self.noEntries = false
                    var index = 0
                    for bookJSON in booksJSON as! [[String: AnyObject]]{
                        let tempAuthor = bookJSON["authors"] as! String
                        let tempTitle = bookJSON["title"] as! String
                        let tempEdition = bookJSON["edition"] as! String
                        let tempPrice = bookJSON["price"] as! String
                        let tempISBN = bookJSON["isbn"] as! String
                        let tempUID = bookJSON["uid"] as! String
                        let isDeleted = bookJSON["isDeleted"] as! Bool
                        if !isDeleted && tempUID == FIRAuth.auth()!.currentUser!.uid{
                            // Load the model with the loaded books and add to the model array
                            self.books.append(Book(isbn: tempISBN, title: tempTitle, author: tempAuthor, edition: tempEdition, price: tempPrice, uid: tempUID, index: index))
                            self.noEntries = false
                        }
                        if(self.books.count == 0){
                            self.noEntries = true
                        }
                        index += 1

                    }
                }else{
                    // nothing loaded so we have no entries.
                    self.noEntries = true
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // Prepares for segue to see the book details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookVC = segue.destination as? BookViewController {
            print("ayy it works in finding right VC")
            bookVC.myBook = books[sender as! Int]
            if divider.selectedSegmentIndex == 0 {
                bookVC.pathSellingOrBuying = "selling"
            }else{
                bookVC.pathSellingOrBuying = "buying"
            }
            
        }
    }

}
