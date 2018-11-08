//
//  Book.swift
//  BookWorm
//
//  Struct to store information about a book.
//  Books have the information below to display them in Table Views and in their
//
//
//
//  Created by Hegde, Vikram on 7/13/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

struct Book {
    var isbn : String = ""
    var title : String = ""
    var author : String = ""
    var edition : String = "Only Edition" // default
    var price : String = "0.00" // default
    var uid : String = "" // Server User ID
    var index : Int = 0 // Index for Table View Selection
}
