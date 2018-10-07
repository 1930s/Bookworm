//
//  BookDetailsFinder.swift
//  BookWorm
//
//  Created by Hegde, Vandana on 8/2/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class BookDetailsFinder: NSObject {
    var isbn : String
    
    //var authors = ""
    init(isbn: String){
        self.isbn = isbn
    }
    
    func getBookTitle() -> String{
        var retStr = "ERROR" // The string that is returned
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfTitles = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.title") as? [String] {
                    retStr = arrayOfTitles.joined(separator: ", ")
                }
                
            }).resume()
            return retStr
        }else{
            return retStr
        }
    }
    
    func getBookAuthor() -> String{
        var retStr = "ERROR" // The string that is returned
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfAuthors = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.authors") as? [[String]] {
                    let authors = arrayOfAuthors.description.substring(with: Range<String.Index>(arrayOfAuthors.description.characters.index(arrayOfAuthors.description.startIndex, offsetBy: 2) ..< arrayOfAuthors.description.characters.index(arrayOfAuthors.description.endIndex, offsetBy: -2))).replacingOccurrences(of: "\"", with: "")
                    retStr = authors
                }
                
            }).resume()
        }
        return retStr
    }
    
    func getBookCoverImageURL() -> String{
        var retStr = "ERROR" // The string that is returned
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []),
                    let arrayOfImageURLs = (jsonResult as AnyObject).value(forKeyPath: "items.volumeInfo.imageLinks.thumbnail") as? [String] {
                    retStr = arrayOfImageURLs.joined(separator: "")
                }
                
            }).resume()
        }
        return retStr
    }

}
