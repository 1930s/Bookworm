//
//  BookDetailsFinder.swift
//  BookWorm
//
//  Class to find information on the books
//  using Google Books API
//
//  Returns the information or the URL for images
//
//  Created by Hegde, Vikram on 8/2/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class BookDetailsFinder: NSObject {
    var isbn : String
    init(isbn: String){ // Just need an ISBN to find the rest from the Google Books API
        self.isbn = isbn
    }
    
    func getBookTitle() -> String{ // API Call
        var retStr = "ERROR" // Default Error
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in // Begin the data task request
                if let error = error {
                    print(error.localizedDescription) // ERROR
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfTitles = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.title") as? [String] { // Using more difficult decoding that Decodable which was introduced in Swift 4
                    retStr = arrayOfTitles.joined(separator: ", ")
                }
                
            }).resume()
            return retStr // Returns Title
        }else{
            return retStr // Returns ERROR
        }
    }
    
    func getBookAuthor() -> String{ // API Call
        var retStr = "ERROR" // Default Error
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in // Begin the data task request
                if let error = error {
                    print(error.localizedDescription) // ERROR
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfAuthors = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.authors") as? [[String]] { // Using more difficult decoding that Decodable which was introduced in Swift 4
                    let authors = arrayOfAuthors.description.substring(with: Range<String.Index>(arrayOfAuthors.description.characters.index(arrayOfAuthors.description.startIndex, offsetBy: 2) ..< arrayOfAuthors.description.characters.index(arrayOfAuthors.description.endIndex, offsetBy: -2))).replacingOccurrences(of: "\"", with: "") // Clippped to remove bounding characters {" and "}
                    retStr = authors
                }
                
            }).resume()
        }
        return retStr // Returns Authors
    }
    
    func getBookCoverImageURL() -> String{ // API Call
        var retStr = "ERROR" // Default Error
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in // Begin the data task request
                if let error = error {
                    print(error.localizedDescription) // ERROR
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfImageURLs = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.imageLinks.thumbnail") as? [String] { // Using more difficult decoding that Decodable which was introduced in Swift 4
                    retStr = arrayOfImageURLs.joined(separator: "")
                }
                
            }).resume()
        }
        return retStr // Returns URL of Cover Image
    }

}
