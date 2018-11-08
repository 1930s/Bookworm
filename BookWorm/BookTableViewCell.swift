//
//  BookTableViewCell.swift
//  BookWorm
//
//  The View Controller to display a Book.
//
//  This will display the Cover, the Title, the Authors, and the Edition
//
//  Created by Hegde, Vikram on 8/27/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var shelf: UIImageView!
    @IBOutlet weak var noBookLabel: UILabel!
    
    var book: Book! = nil

}
